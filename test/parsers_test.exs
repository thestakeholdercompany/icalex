defmodule ICalendarTest.Parsers do
  use ExUnit.Case
  doctest ICalendar
  alias Timex.Duration
  alias ICalendar.Parsers.{ContentLine, ContentLines}
  alias ICalendar.Props.{Parameters, VText, VInt}

  describe "ContentLine" do
    test "parts" do
      assert ContentLine.parts("dtstart:20050101T120000") ==
               {"dtstart", %Parameters{}, "20050101T120000"}

      assert ContentLine.parts("dtstart;value=datetime:20050101T120000") ==
               {"dtstart", %Parameters{parameters: %{"value" => "datetime"}}, "20050101T120000"}

      assert ContentLine.parts(
               "ATTENDEE;CN=Max Rasmussen;ROLE=REQ-PARTICIPANT:MAILTO:maxm@example.com"
             ) ==
               {"attendee",
                %Parameters{parameters: %{"role" => "REQ-PARTICIPANT", "cn" => "Max Rasmussen"}},
                "MAILTO:maxm@example.com"}
    end

    test "to_ical" do
      assert ContentLine.to_ical("foo") == "foo"

      assert ContentLine.to_ical(
               "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum convallis imperdiet dui posuere."
             ) ==
               "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum conval\r\n lis imperdiet dui posuere."

      assert ContentLine.to_ical("foobar", 4) == "foo\r\n bar"

      assert ContentLine.to_ical("DESCRIPTION:АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ", 44) ==
               "DESCRIPTION:АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭ\r\n ЮЯ"
    end

    test "to_ical should raise ArgumentError" do
      assert_raise ArgumentError,
                   "Content line can not contain unescaped new line characters.",
                   fn ->
                     ContentLine.to_ical("some line and\n another line")
                   end
    end

    test "from_parts" do
      assert ContentLine.from_parts("ATTENDEE", %Parameters{}, "MAILTO:maxm@example.com") ==
               "ATTENDEE:MAILTO:maxm@example.com"

      assert ContentLine.from_parts(
               "ATTENDEE",
               %Parameters{parameters: %{"role" => "REQ-PARTICIPANT", "CN" => "Max Rasmussen"}},
               "MAILTO:maxm@example.com"
             ) == "ATTENDEE;CN=\"Max Rasmussen\";ROLE=REQ-PARTICIPANT:MAILTO:maxm@example.com"

      assert ContentLine.from_parts(
               "ATTENDEE",
               %Parameters{},
               %VText{value: "MAILTO:maxm@example.com"}
             ) == "ATTENDEE:MAILTO:maxm@example.com"

      assert ContentLine.from_parts(
               "SOMETHING",
               %Parameters{},
               %VInt{value: 1}
             ) == "SOMETHING:1"

      assert ContentLine.from_parts(
               "SUMMARY",
               %Parameters{},
               %VText{value: "International char æ ø å"}
             ) == "SUMMARY:International char æ ø å"
    end
  end

  describe "ContentLines" do
    test "to_ical" do
      expected =
        "BEGIN:VEVENT\r\n123456789 123456789 123456789 123456789 123456789 123456789 123456789 1234\r\n 56789 123456789 123456789 \r\n"

      assert [
               "BEGIN:VEVENT",
               Stream.cycle(["123456789 "])
               |> Enum.take(10)
               |> Enum.join("")
             ]
             |> ContentLines.to_ical() == expected
    end

    test "from_ical" do
      ics = File.read!("test/sample.ics")

      assert ContentLines.from_ical(ics) == %ICalendar.Components.Component{
               canonical_order: [],
               components: [
                 %ICalendar.Components.Component{
                   canonical_order: [],
                   components: [
                     %ICalendar.Components.Component{
                       canonical_order: [],
                       components: [],
                       exclusive: [],
                       inclusive: [],
                       multiple: [],
                       name: "VALARM",
                       properties: %{
                         "action" => %ICalendar.Props.VText{
                           params: %ICalendar.Props.Parameters{parameters: %{}},
                           value: "DISPLAY"
                         },
                         "description" => %ICalendar.Props.VText{
                           params: %ICalendar.Props.Parameters{parameters: %{}},
                           value: "Pickup Reminder"
                         },
                         "trigger" => %ICalendar.Props.VDuration{
                           params: %ICalendar.Props.Parameters{parameters: %{}},
                           value: Duration.from_minutes(-10)
                         }
                       },
                       required: [],
                       singletons: []
                     }
                   ],
                   exclusive: [],
                   inclusive: [],
                   multiple: [],
                   name: "VEVENT",
                   properties: %{
                     "description" => %ICalendar.Props.VText{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: " Access-A-Ride to 900 Jay St.\\, Brooklyn"
                     },
                     "dtend" => %ICalendar.Props.VDatetime{
                       params: %ICalendar.Props.Parameters{
                         parameters: %{"tzid" => "America/New_York"}
                       },
                       value: ~N[2013-08-02 11:04:00]
                     },
                     "dtstart" => %ICalendar.Props.VDatetime{
                       params: %ICalendar.Props.Parameters{
                         parameters: %{"tzid" => "America/New_York"}
                       },
                       value: ~N[2013-08-02 10:34:00]
                     },
                     "location" => %ICalendar.Props.VText{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: "1000 Broadway Ave.\\, Brooklyn"
                     },
                     "sequence" => %ICalendar.Props.VInt{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: 3
                     },
                     "status" => %ICalendar.Props.VText{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: "CONFIRMED"
                     },
                     "summary" => %ICalendar.Props.VText{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: "Access-A-Ride Pickup"
                     }
                   },
                   required: [],
                   singletons: []
                 },
                 %ICalendar.Components.Component{
                   canonical_order: [],
                   components: [
                     %ICalendar.Components.Component{
                       canonical_order: [],
                       components: [],
                       exclusive: [],
                       inclusive: [],
                       multiple: [],
                       name: "VALARM",
                       properties: %{
                         "action" => %ICalendar.Props.VText{
                           params: %ICalendar.Props.Parameters{parameters: %{}},
                           value: "DISPLAY"
                         },
                         "description" => %ICalendar.Props.VText{
                           params: %ICalendar.Props.Parameters{parameters: %{}},
                           value: "Pickup Reminder"
                         },
                         "trigger" => %ICalendar.Props.VDuration{
                           params: %ICalendar.Props.Parameters{parameters: %{}},
                           value: Duration.from_minutes(-10)
                         }
                       },
                       required: [],
                       singletons: []
                     }
                   ],
                   exclusive: [],
                   inclusive: [],
                   multiple: [],
                   name: "VEVENT",
                   properties: %{
                     "description" => %ICalendar.Props.VText{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: " Access-A-Ride to 1000 Broadway Ave.\\, Brooklyn"
                     },
                     "dtend" => %ICalendar.Props.VDatetime{
                       params: %ICalendar.Props.Parameters{
                         parameters: %{"tzid" => "America/New_York"}
                       },
                       value: ~N[2013-08-02 20:30:00]
                     },
                     "dtstart" => %ICalendar.Props.VDatetime{
                       params: %ICalendar.Props.Parameters{
                         parameters: %{"tzid" => "America/New_York"}
                       },
                       value: ~N[2013-08-02 20:00:00]
                     },
                     "location" => %ICalendar.Props.VText{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: "900 Jay St.\\, Brooklyn"
                     },
                     "sequence" => %ICalendar.Props.VInt{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: 3
                     },
                     "status" => %ICalendar.Props.VText{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: "CONFIRMED"
                     },
                     "summary" => %ICalendar.Props.VText{
                       params: %ICalendar.Props.Parameters{parameters: %{}},
                       value: "Access-A-Ride Pickup"
                     }
                   },
                   required: [],
                   singletons: []
                 }
               ],
               exclusive: [],
               inclusive: [],
               multiple: [],
               name: "VCALENDAR",
               properties: %{
                 "calscale" => %ICalendar.Props.VText{
                   params: %ICalendar.Props.Parameters{parameters: %{}},
                   value: "GREGORIAN"
                 },
                 "version" => %ICalendar.Props.VText{
                   params: %ICalendar.Props.Parameters{parameters: %{}},
                   value: "2.0"
                 }
               },
               required: [],
               singletons: []
             }
    end
  end
end
