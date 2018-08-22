defmodule ICalendarTest.Props do
  use ExUnit.Case
  doctest ICalendar
  alias ICalendar.Props.{VBinary, VBoolean, VFloat, VInt, VDate, VDatetime, VCalAddress}

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
      assert ICal.to_ical(
               %VDate{
                 value: %Date{
                   year: 2001,
                   month: 12,
                   day: 12
                 }
               }
             ) == "20011212"
      assert ICal.to_ical(
               %VDate{
                 value: %Date{
                   year: 1899,
                   month: 1,
                   day: 1
                 }
               }
             ) == "18990101"
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
      assert ICal.to_ical(
               %VDatetime{
                 value: datetime
               }
             ) == "20010102030405Z"

      assert ICal.to_ical(
               %VDatetime{
                 value: DateTime.to_naive(datetime)
               }
             ) == "20010102030405"
    end
  end
  describe "VCalAddress" do
    test "to_ical" do
      text = "MAILTO:maxm@mxm.dk"
      assert ICal.to_ical(%VCalAddress{value: text}) == text
    end
  end
  describe "VBinary" do
    test "to_ical" do
      assert ICal.to_ical(%VBinary{value: "This is gibberish"}) == "VGhpcyBpcyBnaWJiZXJpc2g="
    end
  end
end
