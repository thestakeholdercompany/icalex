defmodule ICalendarTest.Components do
  use ExUnit.Case
  doctest ICalendar

  alias ICalendar.Parsers.{ContentLine, ContentLines}

  alias ICalendar.Components.{
    Alarm,
    Calendar,
    Component,
    Event,
    FreeBusy,
    Journal,
    Timezone,
    TimezoneDaylight,
    TimezoneStandard,
    Todo
  }

  describe "Alarm" do
    test "to_ical with no sub components" do
      component_name = "VALARM"
      component = %Alarm{}
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end

    test "to_ical with properties" do
      component = %Alarm{
        properties: %{
          "ATTENDEE" => "Max M"
        }
      }

      assert Component.is_empty(component) == false
      assert Component.to_ical(component) == "BEGIN:VALARM\r\nATTENDEE:Max M\r\nEND:VALARM\r\n"
    end
  end

  describe "Calendar" do
    test "to_ical with no sub components" do
      component_name = "VCALENDAR"
      component = %Calendar{}
      assert component.name == component_name
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end

    test "to_ical with properties" do
      component = %Calendar{
        properties: %{
          "DESCRIPTION" => "Paragraph one\n\nParagraph two"
        }
      }

      assert Component.is_empty(component) == false
#     FIXME assert Component.to_ical(component) == "BEGIN:VCALENDAR\r\nDESCRIPTION:Paragraph one\\n\\nParagraph two\r\nEND:VCALENDAR\r\n"
    end
  end

  describe "Event" do
    test "to_ical with no sub components" do
      component_name = "VEVENT"
      component = %Event{}
      assert component.name == component_name
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end
  end

  describe "FreeBusy" do
    test "to_ical with no sub components" do
      component_name = "VFREEBUSY"
      component = %FreeBusy{}
      assert component.name == component_name
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end
  end

  describe "Journal" do
    test "to_ical with no sub components" do
      component_name = "VJOURNAL"
      component = %Journal{}
      assert component.name == component_name
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end
  end

  describe "Timezone" do
    test "to_ical with no sub components" do
      component_name = "VTIMEZONE"
      component = %Timezone{}
      assert component.name == component_name
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end
  end

  describe "TimezoneDaylight" do
    test "to_ical with no sub components" do
      component_name = "DAYLIGHT"
      component = %TimezoneDaylight{}
      assert component.name == component_name
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end
  end

  describe "TimezoneStandard" do
    test "to_ical with no sub components" do
      component_name = "STANDARD"
      component = %TimezoneStandard{}
      assert component.name == component_name
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end
  end

  describe "Todo" do
    test "to_ical with no sub components" do
      component_name = "VTODO"
      component = %Todo{}
      assert component.name == component_name
      assert component.name == component_name

      assert Component.to_ical(component) ==
               "BEGIN:#{component_name}\r\nEND:#{component_name}\r\n"

      assert Component.is_empty(component)
    end
  end
end
