defmodule ICalendarTest.Props do
  use ExUnit.Case
  doctest ICalendar

  alias Timex.Duration

  alias ICalendar.Props

  alias ICalendar.Props.{
    Factory,
    Parameters,
    VBinary,
    VBoolean,
    VCalAddress,
    VDate,
    VDatetime,
    VDDDLists,
    VDDDTypes,
    VDuration,
    VFloat,
    VFrequency,
    VGeo,
    VInline,
    VInt,
    VPeriod,
    VRecur,
    VText,
    VTime,
    VUri,
    VUTCOffset,
    VWeekday
  }

  @date %Date{
    year: 2001,
    month: 12,
    day: 12
  }

  @date_time %DateTime{
    year: 2001,
    month: 1,
    day: 2,
    hour: 3,
    minute: 4,
    second: 5,
    time_zone: "Etc/UTC",
    zone_abbr: "UTC",
    utc_offset: 0,
    std_offset: 0
  }

  describe "Factory" do
    test "get_type binary should retrieve VBinary" do
      value = "some text"
      params = %Parameters{parameters: %{encoding: "BASE64", value: "BINARY"}}
      assert Factory.get_type("binary", value, params) == %VBinary{value: value}
    end

    test "from_ical binary should retrieve VBinary" do
      #      value = Base.encode64("hello")
      #      FIXME assert Factory.from_ical("binary", value) == VBinary.of(value)
    end

    test "get_type boolean should retrieve VBoolean" do
      value = true
      assert Factory.get_type("boolean", value) == %VBoolean{value: value}
    end

    test "get_type cal-address should retrieve VCalAddress" do
      value = "some address"
      assert Factory.get_type("cal-address", value) == %VCalAddress{value: value}
    end

    test "get_type text should retrieve VText" do
      value = "some value"
      assert Factory.get_type("text", value) == %VText{value: value}
      assert Factory.get_type("unknown type", value) == %VText{value: value}
    end

    test "get_type float should retrieve VFloat" do
      value = 1.0
      assert Factory.get_type("float", value) == %VFloat{value: value}
    end

    test "get_type integer should retrieve VInt" do
      value = 1
      assert Factory.get_type("integer", value) == %VInt{value: value}
    end

    test "get_type geo should retrieve VGeo" do
      value = {1.3667, 103.8}
      assert Factory.get_type("geo", value) == %VGeo{value: value}
    end

    test "get_type inline should retrieve VInline" do
      value = "some raw string"
      assert Factory.get_type("inline", value) == %VInline{value: value}
    end

    test "get_type uri should retrieve VUri" do
      value = "http://somewhere.com"
      assert Factory.get_type("uri", value) == %VUri{value: value}
    end

    test "get_type time should retrieve VTime" do
      value = {12, 34, 56}
      assert Factory.get_type("time", value) == %VTime{value: ~T[12:34:56]}
    end

    test "get_type recur should retrieve VFloat" do
      assert Factory.get_type("recur", %{}) == %VRecur{value: %{}}
    end

    test "get_type recur should retrieve VWeekday" do
      assert Factory.get_type("weekday", "+3mo") == %VWeekday{
               value: %{
                 "relative" => "3",
                 "signal" => "+",
                 "weekday" => "mo"
               }
             }
    end

    test "get_type frequency should retrieve VFrequency" do
      assert Factory.get_type("frequency", "daily") == %VFrequency{value: "DAILY"}
    end

    test "get_type date-time-list should retrieve VDDDTypes" do
      assert Factory.get_type("date-time-list", @date_time) == %VDDDLists{
               value: [VDDDTypes.of(@date_time)]
             }
    end

    test "get_type duration should retrieve VDuration" do
      value = %Duration{megaseconds: 0, seconds: 0, microseconds: 0}

      assert Factory.get_type("duration", value) == %VDuration{
               value: value
             }
    end

    test "get_type period should retrieve VPeriod" do
      assert Factory.get_type("period", {@date_time, @date_time}) == %VPeriod{
               value: {@date_time, @date_time}
             }
    end
  end

  describe "VBinary" do
    test "of" do
      value = "This is gibberish"
      assert VBinary.of(value) == %VBinary{value: value}
      params = %Parameters{parameters: %{some: "value"}}
      assert VBinary.of(value, params) == %VBinary{value: value, params: params}
    end

    test "to_ical" do
      assert ICal.to_ical(VBinary.of("This is gibberish")) == "VGhpcyBpcyBnaWJiZXJpc2g="
    end

    test "is_prop" do
      assert Props.is_prop(VBinary.of("This is gibberish"))
    end

    test "from" do
      assert VBinary.from("VGhpcyBpcyBnaWJiZXJpc2g=") == VBinary.of("This is gibberish")

      assert_raise ArgumentError, "Expected a base 64 encoding, got: bad value", fn ->
        VBinary.from("bad value")
      end
    end
  end

  describe "VBoolean" do
    test "of" do
      assert VBoolean.of(true) == %VBoolean{value: true}
      assert VBoolean.of(false) == %VBoolean{value: false}
    end

    test "to_ical" do
      assert ICal.to_ical(VBoolean.of(true)) == "TRUE"
      assert ICal.to_ical(VBoolean.of(false)) == "FALSE"
    end

    test "is_prop" do
      assert Props.is_prop(VBoolean.of(true))
    end

    test "from" do
      assert VBoolean.from("TrUe") == VBoolean.of(true)
      assert VBoolean.from("false") == VBoolean.of(false)

      assert_raise ArgumentError, "Expected \"true\" or \"false\", got: bad value", fn ->
        VBoolean.from("bad value")
      end
    end
  end

  describe "VFloat" do
    test "of" do
      assert VFloat.of(1.6) == %VFloat{value: 1.6}
    end

    test "to_ical" do
      assert ICal.to_ical(VFloat.of(1.6)) == "1.6"
    end

    test "is_prop" do
      assert Props.is_prop(VFloat.of(1.6))
    end

    test "from" do
      assert VFloat.from("1.5") == VFloat.of(1.5)

      assert_raise ArgumentError, "Expected a float, got: bad value", fn ->
        VFloat.from("bad value")
      end
    end
  end

  describe "VInt" do
    test "of" do
      assert VInt.of(123) == %VInt{value: 123}
    end

    test "to_ical" do
      assert ICal.to_ical(VInt.of(123)) == "123"
    end

    test "is_prop" do
      assert Props.is_prop(VInt.of(123))
    end

    test "from" do
      assert VInt.from("5") == VInt.of(5)

      assert_raise ArgumentError, "Expected an int, got: bad value", fn ->
        VInt.from("bad value")
      end
    end
  end

  describe "VDate" do
    test "of" do
      assert VDate.of(@date) == %VDate{value: @date}
    end

    test "to_ical" do
      assert ICal.to_ical(VDate.of(@date)) == "20011212"
    end

    test "is_prop" do
      assert Props.is_prop(VDate.of(@date))
    end

    test "from" do
      assert VDate.from("20011212") == VDate.of(@date)

      assert_raise ArgumentError, "Expected a date, got: bad value", fn ->
        VDate.from("bad value")
      end
    end
  end

  describe "VDatetime" do
    test "of" do
      assert VDatetime.of(@date_time) == %VDatetime{
               value: @date_time
             }

      assert VDatetime.of(DateTime.to_naive(@date_time)) == %VDatetime{
               value: DateTime.to_naive(@date_time)
             }
    end

    test "to_ical" do
      assert ICal.to_ical(VDatetime.of(@date_time)) == "20010102T030405Z"
      assert ICal.to_ical(VDatetime.of(DateTime.to_naive(@date_time))) == "20010102T030405"
    end

    test "is_prop" do
      assert Props.is_prop(VDatetime.of(@date_time))
    end

    test "from" do
      assert VDatetime.from("20010102T030405") == VDatetime.of(DateTime.to_naive(@date_time))
      assert VDatetime.from("20010102T030405Z") == VDatetime.of(@date_time)

      assert_raise ArgumentError, "Expected a date time, got: bad value", fn ->
        VDatetime.from("bad value")
      end
    end
  end

  describe "VDDDTypes" do
    test "of" do
      assert VDDDTypes.of(@date) == %VDDDTypes{
               value: @date
             }

      assert VDDDTypes.of(@date_time) == %VDDDTypes{
               value: @date_time
             }

      assert VDDDTypes.of(DateTime.to_naive(@date_time)) == %VDDDTypes{
               value: DateTime.to_naive(@date_time)
             }

      value = {12, 34, 56}

      assert VDDDTypes.of(value) == %VDDDTypes{
               value: value
             }
    end

    test "to_ical" do
      assert ICal.to_ical(VDDDTypes.of(@date)) == "20011212"
      assert ICal.to_ical(VDDDTypes.of(@date_time)) == "20010102T030405Z"
      assert ICal.to_ical(VDDDTypes.of(DateTime.to_naive(@date_time))) == "20010102T030405"
      assert ICal.to_ical(VDDDTypes.of({12, 34, 56})) == "123456"
    end

    test "is_prop" do
      assert Props.is_prop(VDDDTypes.of(@date))
    end
  end

  describe "VPeriod" do
    test "of" do
      assert VPeriod.of({@date_time, @date_time}) == %VPeriod{
               value: {@date_time, @date_time}
             }

      assert VPeriod.of({DateTime.to_naive(@date_time), DateTime.to_naive(@date_time)}) ==
               %VPeriod{
                 value: {DateTime.to_naive(@date_time), DateTime.to_naive(@date_time)}
               }
    end

    test "to_ical" do
      assert ICal.to_ical(VPeriod.of({@date_time, @date_time})) ==
               "20010102T030405Z/20010102T030405Z"

      assert ICal.to_ical(
               VPeriod.of({DateTime.to_naive(@date_time), DateTime.to_naive(@date_time)})
             ) == "20010102T030405/20010102T030405"

      duration = %Duration{megaseconds: 0, seconds: 28800, microseconds: 0}
      assert ICal.to_ical(VPeriod.of({@date_time, duration})) == "20010102T030405Z/PT8H"

      duration = %Duration{megaseconds: 0, seconds: 28800, microseconds: 0}

      assert ICal.to_ical(VPeriod.of({DateTime.to_naive(@date_time), duration})) ==
               "20010102T030405/PT8H"
    end

    test "is_prop" do
      assert Props.is_prop(VPeriod.of({@date_time, @date_time}))
    end

    test "from" do
      assert VPeriod.from("20010102T030405Z/20010102T030405Z") ==
               VPeriod.of({@date_time, @date_time})

      assert VPeriod.from("20010102T030405/20010102T030405") ==
               VPeriod.of({DateTime.to_naive(@date_time), DateTime.to_naive(@date_time)})

      duration = %Duration{megaseconds: 0, seconds: 28800, microseconds: 0}
      assert VPeriod.from("20010102T030405Z/PT8H") == VPeriod.of({@date_time, duration})

      assert_raise ArgumentError, "Expected a period, got: bad value", fn ->
        VPeriod.from("bad value")
      end
    end
  end

  describe "VCalAddress" do
    test "of" do
      value = "MAILTO:maxm@mxm.dk"
      assert VCalAddress.of(value) == %VCalAddress{value: value}
    end

    test "to_ical" do
      value = "MAILTO:maxm@mxm.dk"
      assert ICal.to_ical(VCalAddress.of(value)) == value
    end

    test "is_prop" do
      assert Props.is_prop(VCalAddress.of("MAILTO:maxm@mxm.dk"))
    end

    test "from" do
      assert VCalAddress.from("some address") == VCalAddress.of("some address")
    end
  end

  describe "VText" do
    test "of" do
      value = "Simple text"
      assert VText.of(value) == %VText{value: value}
    end

    test "to_ical" do
      value = "Simple text"
      assert ICal.to_ical(VText.of(value)) == value

      assert ICal.to_ical(VText.of("Text ; with escaped, chars")) ==
               "Text \\; with escaped\\, chars"
    end

    test "is_prop" do
      assert Props.is_prop(VText.of("Simple text"))
    end

    test "from" do
      assert VText.from("Simple text") == VText.of("Simple text")
    end
  end

  describe "VGeo" do
    test "of" do
      value = {1.3667, 103.8}
      assert VGeo.of(value) == %VGeo{value: value}
    end

    test "to_ical" do
      assert ICal.to_ical(VGeo.of({1.3667, 103.8})) == "1.3667;103.8"
    end

    test "is_prop" do
      assert Props.is_prop(VGeo.of({1.3667, 103.8}))
    end

    test "from" do
      assert VGeo.from("1.3667;103.8") == VGeo.of({1.3667, 103.8})

      assert_raise ArgumentError, ~s(Expected a "latitude;longitude", got: bad value), fn ->
        VGeo.from("bad value")
      end
    end
  end

  describe "VInline" do
    test "of" do
      value = "some raw string"
      assert VInline.of(value) == %VInline{value: value}
    end

    test "to_ical" do
      value = "some raw string"
      assert ICal.to_ical(VInline.of(value)) == value
    end

    test "is_prop" do
      assert Props.is_prop(VInline.of("some raw string"))
    end

    test "from" do
      value = "some raw string"
      assert VInline.from(value) == VInline.of(value)
    end
  end

  describe "VUri" do
    test "of" do
      value = "http://somewhere.com"
      assert VUri.of(value) == %VUri{value: value}
    end

    test "to_ical" do
      value = "http://somewhere.com"
      assert ICal.to_ical(VUri.of(value)) == value
    end

    test "is_prop" do
      assert Props.is_prop(VUri.of("http://somewhere.com"))
    end

    test "from" do
      assert VUri.from("http://somewhere.com") == VUri.of("http://somewhere.com")
    end
  end

  describe "VTime" do
    test "of" do
      assert VTime.of({12, 34, 56}) == %VTime{value: %Time{hour: 12, minute: 34, second: 56}}

      assert VTime.of(%Time{hour: 12, minute: 34, second: 56}) == %VTime{
               value: %Time{hour: 12, minute: 34, second: 56}
             }
    end

    test "to_ical" do
      assert ICal.to_ical(VTime.of({12, 34, 56})) == "123456"
    end

    test "is_prop" do
      assert Props.is_prop(VTime.of({12, 34, 56}))
    end

    test "from" do
      assert VTime.from("123456") == VTime.of({12, 34, 56})

      assert_raise ArgumentError, "Expected a time, got: bad value", fn ->
        VTime.from("bad value")
      end
    end
  end

  describe "VUTCOffset" do
    test "of" do
      value = %Duration{megaseconds: 0, seconds: 0, microseconds: 0}
      assert VUTCOffset.of(value) == %VUTCOffset{value: value}
    end

    test "to_ical" do
      assert ICal.to_ical(VUTCOffset.of(%Duration{megaseconds: 0, seconds: 0, microseconds: 0})) ==
               "+0000"

      assert ICal.to_ical(
               VUTCOffset.of(%Duration{megaseconds: 0, seconds: 7200, microseconds: 0})
             ) == "+0200"

      assert ICal.to_ical(
               VUTCOffset.of(%Duration{megaseconds: 0, seconds: -18000, microseconds: 0})
             ) == "-0500"

      assert ICal.to_ical(
               VUTCOffset.of(%Duration{megaseconds: 0, seconds: -1800, microseconds: 0})
             ) == "-0030"

      assert ICal.to_ical(
               VUTCOffset.of(%Duration{megaseconds: 0, seconds: 5400, microseconds: 0})
             ) == "+0130"

      assert ICal.to_ical(
               VUTCOffset.of(%Duration{megaseconds: 0, seconds: 5407, microseconds: 0})
             ) == "+013007"
    end

    test "is_prop" do
      value = %Duration{megaseconds: 0, seconds: 0, microseconds: 0}
      assert Props.is_prop(VUTCOffset.of(value))
    end
  end

  describe "VDDDLists" do
    test "of" do
      assert VDDDLists.of(@date_time) == %VDDDLists{value: [VDDDTypes.of(@date_time)]}

      assert VDDDLists.of([@date_time, @date_time]) == %VDDDLists{
               value: [VDDDTypes.of(@date_time), VDDDTypes.of(@date_time)]
             }
    end

    test "to_ical" do
      assert ICal.to_ical(VDDDLists.of([])) == ""
      assert ICal.to_ical(VDDDLists.of(@date_time)) == "20010102T030405Z"

      assert ICal.to_ical(VDDDLists.of([@date_time, @date_time])) ==
               "20010102T030405Z,20010102T030405Z"
    end

    test "is_prop" do
      assert Props.is_prop(VDDDLists.of(@date_time))
    end
  end

  describe "VRecur" do
    test "of" do
      assert VRecur.of(%{}) == %VRecur{value: %{}}
    end

    test "to_ical" do
      assert ICal.to_ical(
               VRecur.of(%{
                 "freq" => "yearly",
                 "interval" => 2,
                 "bymonth" => 1,
                 "byday" => "su",
                 "byhour" => [8, 9],
                 "byminute" => 30
               })
             ) == "FREQ=YEARLY;INTERVAL=2;BYMINUTE=30;BYHOUR=8,9;BYDAY=SU;BYMONTH=1"

      assert ICal.to_ical(
               VRecur.of(%{
                 "FREQ" => "DAILY",
                 "COUNT" => 10,
                 "BYSECOND" => [0, 15, 30, 45]
               })
             ) == "FREQ=DAILY;COUNT=10;BYSECOND=0,15,30,45"

      assert ICal.to_ical(
               VRecur.of(%{
                 "freq" => "DAILY",
                 "until" => %NaiveDateTime{
                   year: 2005,
                   month: 1,
                   day: 1,
                   hour: 12,
                   minute: 0,
                   second: 0
                 }
               })
             ) == "FREQ=DAILY;UNTIL=20050101T120000"
    end

    test "is_prop" do
      assert Props.is_prop(VRecur.of(%{}))
    end
  end

  describe "VWeekday" do
    test "of" do
      assert VWeekday.of("+3mo") == %VWeekday{
               value: %{
                 "relative" => "3",
                 "signal" => "+",
                 "weekday" => "mo"
               }
             }
    end

    test "of should drop bad signal" do
      assert VWeekday.of("*3mo") == %VWeekday{
               value: %{
                 "relative" => "3",
                 "signal" => "",
                 "weekday" => "mo"
               }
             }
    end

    test "of should raise ArgumentError when bad weekday" do
      assert_raise ArgumentError, "Expected weekday, got: om", fn ->
        VWeekday.of("2om")
      end
    end

    test "to_ical" do
      assert ICal.to_ical(VWeekday.of("mo")) == "MO"
      assert ICal.to_ical(VWeekday.of("+mo")) == "+MO"
      assert ICal.to_ical(VWeekday.of("+3mo")) == "+3MO"
      assert ICal.to_ical(VWeekday.of("-tu")) == "-TU"
    end

    test "is_prop" do
      assert Props.is_prop(VWeekday.of("mo"))
    end
  end

  describe "VFrequency" do
    test "of" do
      ["secondly", "minutely", "hourly", "daily", "weekly", "monthly", "yearly"]
      |> Enum.each(fn f -> assert VFrequency.of(f) == %VFrequency{value: String.upcase(f)} end)
    end

    test "of should raise ArgumentError" do
      assert_raise ArgumentError, "Expected frequency, got: boum", fn ->
        VFrequency.of("boum")
      end
    end

    test "to_ical" do
      ["secondly", "minutely", "hourly", "daily", "weekly", "monthly", "yearly"]
      |> Enum.each(fn f ->
        assert ICal.to_ical(VFrequency.of(f)) == String.upcase(f)
      end)
    end

    test "is_prop" do
      assert Props.is_prop(VFrequency.of("yearly"))
    end
  end

  describe "VDuration" do
    test "of" do
      value = %Duration{megaseconds: 0, seconds: 0, microseconds: 0}

      assert VDuration.of(value) == %VDuration{
               value: value
             }
    end

    test "to_ical" do
      value = %Duration{megaseconds: 0, seconds: 0, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "P"
      value = %Duration{megaseconds: 0, seconds: 86400, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "P1D"
      value = %Duration{megaseconds: 0, seconds: -86400, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "-P1D"
      value = %Duration{megaseconds: 0, seconds: 86400 + 3600, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "P1DT1H"
      value = %Duration{megaseconds: 0, seconds: -86400 - 3600, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "-P1DT1H"
      value = %Duration{megaseconds: 0, seconds: 86400 + 3600 + 1800, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "P1DT1H30M"
      value = %Duration{megaseconds: 0, seconds: -86400 - 3600 - 1800, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "-P1DT1H30M"
      value = %Duration{megaseconds: 0, seconds: 86400 + 3600 + 1800 + 10, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "P1DT1H30M10S"
      value = %Duration{megaseconds: 0, seconds: -86400 - 3600 - 1800 - 10, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "-P1DT1H30M10S"
      value = %Duration{megaseconds: 0, seconds: 10, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "PT10S"
      value = %Duration{megaseconds: 0, seconds: -10, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "-PT10S"
      value = %Duration{megaseconds: 0, seconds: 1800, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "PT30M"
      value = %Duration{megaseconds: 0, seconds: -1800, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "-PT30M"
      value = %Duration{megaseconds: 0, seconds: 3600, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "PT1H"
      value = %Duration{megaseconds: 0, seconds: -3600, microseconds: 0}
      assert ICal.to_ical(VDuration.of(value)) == "-PT1H"
    end

    test "is_prop" do
      value = %Duration{megaseconds: 0, seconds: 0, microseconds: 0}
      assert Props.is_prop(VDuration.of(value))
    end

    test "from" do
      value = %Duration{megaseconds: 0, seconds: 0, microseconds: 0}
      assert VDuration.from("P") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: 86400, microseconds: 0}
      assert VDuration.from("P1D") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: -86400, microseconds: 0}
      assert VDuration.from("-P1D") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: 86400 + 3600, microseconds: 0}
      assert VDuration.from("P1DT1H") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: -86400 - 3600, microseconds: 0}
      assert VDuration.from("-P1DT1H") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: 86400 + 3600 + 1800, microseconds: 0}
      assert VDuration.from("P1DT1H30M") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: -86400 - 3600 - 1800, microseconds: 0}
      assert VDuration.from("-P1DT1H30M") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: 86400 + 3600 + 1800 + 10, microseconds: 0}
      assert VDuration.from("P1DT1H30M10S") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: -86400 - 3600 - 1800 - 10, microseconds: 0}
      assert VDuration.from("-P1DT1H30M10S") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: 10, microseconds: 0}
      assert VDuration.from("PT10S") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: -10, microseconds: 0}
      assert VDuration.from("-PT10S") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: 1800, microseconds: 0}
      assert VDuration.from("PT30M") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: -1800, microseconds: 0}
      assert VDuration.from("-PT30M") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: 3600, microseconds: 0}
      assert VDuration.from("PT1H") == VDuration.of(value)
      value = %Duration{megaseconds: 0, seconds: -3600, microseconds: 0}
      assert VDuration.from("-PT1H") == VDuration.of(value)

      assert_raise ArgumentError, "Expected a duration, got: bad value", fn ->
        VDuration.from("bad value")
      end
    end
  end
end
