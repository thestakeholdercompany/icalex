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
    VFloat,
    VGeo,
    VInline,
    VInt,
    VText,
    VTime,
    VUri
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
      assert Factory.get_type("integer", value) == %VInt{value: value}
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
  end

  describe "VBoolean" do
    test "to_ical" do
      assert ICal.to_ical(%VBoolean{value: true}) == "TRUE"
      assert ICal.to_ical(%VBoolean{value: false}) == "FALSE"
    end
  end

  describe "VFloat" do
    test "to_ical" do
      assert ICal.to_ical(%VFloat{value: 1.6}) == "1.6"
    end
  end

  describe "VInt" do
    test "to_ical" do
      assert ICal.to_ical(%VInt{value: 123}) == "123"
    end
  end

  describe "VDate" do
    test "to_ical" do
      assert ICal.to_ical(%VDate{
               value: %Date{
                 year: 2001,
                 month: 12,
                 day: 12
               }
             }) == "20011212"

      assert ICal.to_ical(%VDate{
               value: %Date{
                 year: 1899,
                 month: 1,
                 day: 1
               }
             }) == "18990101"
    end
  end

  describe "VDatetime" do
    test "to_ical" do
      datetime = %DateTime{
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

      assert ICal.to_ical(%VDatetime{
               value: datetime
             }) == "20010102T030405Z"

      assert ICal.to_ical(%VDatetime{
               value: DateTime.to_naive(datetime)
             }) == "20010102T030405"
    end
  end

  describe "VCalAddress" do
    test "to_ical" do
      value = "MAILTO:maxm@mxm.dk"
      assert ICal.to_ical(%VCalAddress{value: value}) == value
    end
  end

  describe "VText" do
    test "to_ical" do
      value = "Simple text"
      assert ICal.to_ical(%VText{value: value}) == value

      assert ICal.to_ical(%VText{value: "Text ; with escaped, chars"}) ==
               "Text \\; with escaped\\, chars"

      # FIXME: assert ICal.to_ical(%VText{value: "Text with escaped\\N chars"}) == "Text with escaped\\n chars"
    end
  end

  describe "VBinary" do
    test "to_ical" do
      assert ICal.to_ical(%VBinary{value: "This is gibberish"}) == "VGhpcyBpcyBnaWJiZXJpc2g="
    end
  end

  describe "VGeo" do
    test "to_ical" do
      assert ICal.to_ical(%VGeo{value: {1.3667, 103.8}}) == "1.3667;103.8"
    end
  end

  describe "VInline" do
    test "to_ical" do
      value = "some raw string"
      assert ICal.to_ical(%VInline{value: value}) == value
    end
  end

  describe "VUri" do
    test "to_ical" do
      value = "http://somewhere.com"
      assert ICal.to_ical(%VUri{value: value}) == value
    end
  end

  describe "VTime" do
    test "to_ical" do
      assert ICal.to_ical(%VTime{value: {12, 34, 56}}) == "123456"
    end
  end
end
