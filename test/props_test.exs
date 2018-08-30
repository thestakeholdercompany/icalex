defmodule ICalendarTest.Props do
  use ExUnit.Case
  doctest ICalendar

  alias ICalendar.Props.{
    Factory,
    Parameters,
    VBinary,
    VBoolean,
    VCalAddress,
    VDate,
    VDatetime,
    VDDDTypes,
    VFloat,
    VFrequency,
    VGeo,
    VInline,
    VInt,
    VRecur,
    VText,
    VTime,
    VUri,
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
    test "get_type binary should retrieve VBoolean" do
      value = "some text"
      params = %Parameters{parameters: %{encoding: "BASE64", value: "BINARY"}}
      assert Factory.get_type("binary", value, params) == %VBinary{value: value}
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
      assert Factory.get_type("time", value) == %VTime{value: value}
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

    test "get_type recur should retrieve VFrequency" do
      assert Factory.get_type("frequency", "daily") == %VFrequency{value: "DAILY"}
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
  end

  describe "VFloat" do
    test "of" do
      assert VFloat.of(1.6) == %VFloat{value: 1.6}
    end

    test "to_ical" do
      assert ICal.to_ical(VFloat.of(1.6)) == "1.6"
    end
  end

  describe "VInt" do
    test "of" do
      assert VInt.of(123) == %VInt{value: 123}
    end

    test "to_ical" do
      assert ICal.to_ical(VInt.of(123)) == "123"
    end
  end

  describe "VDate" do
    test "of" do
      assert VDate.of(@date) == %VDate{value: @date}
    end

    test "to_ical" do
      assert ICal.to_ical(VDate.of(@date)) == "20011212"
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

      # FIXME: assert ICal.to_ical(%VText{value: "Text with escaped\\N chars"}) == "Text with escaped\\n chars"
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
  end

  describe "VTime" do
    test "of" do
      value = {12, 34, 56}
      assert VTime.of(value) == %VTime{value: {12, 34, 56}}
    end

    test "to_ical" do
      assert ICal.to_ical(VTime.of({12, 34, 56})) == "123456"
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

    # TODO improve this later
    #    test "of should raise ArgumentError when bad signal" do
    #      assert_raise ArgumentError, "Expected frequency, got: *", fn ->
    #        VWeekday.of("*3mo")
    #      end
    #    end

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
  end
end
