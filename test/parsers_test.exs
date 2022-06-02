defmodule ICalexTest.Parsers do
  use ExUnit.Case
  doctest ICalex
  alias Timex.Duration
  alias ICalex.Parsers.{ContentLine, ContentLines}
  alias ICalex.Props.{Parameters, VText, VInt}

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

      assert ContentLines.from_ical(ics) == %ICalex.Components.Component{
               canonical_order: [],
               components: [
                 %ICalex.Components.Component{
                   canonical_order: [],
                   components: [
                     %ICalex.Components.Component{
                       canonical_order: [],
                       components: [],
                       exclusive: [],
                       inclusive: [],
                       multiple: [],
                       name: "VALARM",
                       properties: %{
                         "action" => %ICalex.Props.VText{
                           params: %ICalex.Props.Parameters{parameters: %{}},
                           value: "DISPLAY"
                         },
                         "description" => %ICalex.Props.VText{
                           params: %ICalex.Props.Parameters{parameters: %{}},
                           value: "Pickup Reminder"
                         },
                         "trigger" => %ICalex.Props.VDuration{
                           params: %ICalex.Props.Parameters{parameters: %{}},
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
                     "description" => %ICalex.Props.VText{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: " Access-A-Ride to 900 Jay St.\\, Brooklyn"
                     },
                     "dtend" => %ICalex.Props.VDatetime{
                       params: %ICalex.Props.Parameters{
                         parameters: %{"tzid" => "America/New_York"}
                       },
                       value: ~N[2013-08-02 11:04:00]
                     },
                     "dtstart" => %ICalex.Props.VDatetime{
                       params: %ICalex.Props.Parameters{
                         parameters: %{"tzid" => "America/New_York"}
                       },
                       value: ~N[2013-08-02 10:34:00]
                     },
                     "location" => %ICalex.Props.VText{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: "1000 Broadway Ave.\\, Brooklyn"
                     },
                     "sequence" => %ICalex.Props.VInt{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: 3
                     },
                     "status" => %ICalex.Props.VText{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: "CONFIRMED"
                     },
                     "summary" => %ICalex.Props.VText{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: "Access-A-Ride Pickup"
                     }
                   },
                   required: [],
                   singletons: []
                 },
                 %ICalex.Components.Component{
                   canonical_order: [],
                   components: [
                     %ICalex.Components.Component{
                       canonical_order: [],
                       components: [],
                       exclusive: [],
                       inclusive: [],
                       multiple: [],
                       name: "VALARM",
                       properties: %{
                         "action" => %ICalex.Props.VText{
                           params: %ICalex.Props.Parameters{parameters: %{}},
                           value: "DISPLAY"
                         },
                         "description" => %ICalex.Props.VText{
                           params: %ICalex.Props.Parameters{parameters: %{}},
                           value: "Pickup Reminder"
                         },
                         "trigger" => %ICalex.Props.VDuration{
                           params: %ICalex.Props.Parameters{parameters: %{}},
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
                     "description" => %ICalex.Props.VText{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: " Access-A-Ride to 1000 Broadway Ave.\\, Brooklyn"
                     },
                     "dtend" => %ICalex.Props.VDatetime{
                       params: %ICalex.Props.Parameters{
                         parameters: %{"tzid" => "America/New_York"}
                       },
                       value: ~N[2013-08-02 20:30:00]
                     },
                     "dtstart" => %ICalex.Props.VDatetime{
                       params: %ICalex.Props.Parameters{
                         parameters: %{"tzid" => "America/New_York"}
                       },
                       value: ~N[2013-08-02 20:00:00]
                     },
                     "location" => %ICalex.Props.VText{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: "900 Jay St.\\, Brooklyn"
                     },
                     "sequence" => %ICalex.Props.VInt{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: 3
                     },
                     "status" => %ICalex.Props.VText{
                       params: %ICalex.Props.Parameters{parameters: %{}},
                       value: "CONFIRMED"
                     },
                     "summary" => %ICalex.Props.VText{
                       params: %ICalex.Props.Parameters{parameters: %{}},
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
                 "calscale" => %ICalex.Props.VText{
                   params: %ICalex.Props.Parameters{parameters: %{}},
                   value: "GREGORIAN"
                 },
                 "version" => %ICalex.Props.VText{
                   params: %ICalex.Props.Parameters{parameters: %{}},
                   value: "2.0"
                 }
               },
               required: [],
               singletons: []
             }
    end

    test "round trip" do
      # TODO round trip test
      #      ics = File.read!("test/sample.ics")
      #      assert ContentLines.from_ical(ics) |> Component.to_ical() == ics
    end

    test "handling incorrect linebreaks" do
      # Scenario: There are some linebreaks in the middle of some fields.
      # Expectation: ical string can be converted to ICalex Component
      test_data = "BEGIN:VCALENDAR\r\nPRODID:-//Google Inc//Google Calendar 70.9054//EN\r\nVERSION:2.0\r\nCALSCALE:GREGORIAN\r\nMETHOD:REQUEST\r\nBEGIN:VEVENT\r\nDTSTART:20220601T043000Z\r\nDTEND:20220601T050000Z\r\nDTSTAMP:20220531T013709Z\r\nORGANIZER;CN=kimhoang@tsc.ai:mailto:someone@tsc.ai\r\nUID:040000008200E00074C5B7101A82E008000000004A92673A0974D801000000000000000\r\n 0100000003AA8F50FFD17984585F51196380DC9C6\r\nATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=\r\n TRUE;CN=12345c@inbound.postmarkapp.com;X-NUM-GUES\r\nTS=0:mailto:12345c@inbound.postmarkapp.com\r\nX-MICROSOFT-CDO-OWNERAPPTID:-674825255\r\nCREATED:20220530T093959Z\r\nDESCRIPTION:-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~\r\n :~:~:~:~:~:~:~:~::~:~::-\\nDo not edit this section of the description.\\n\\nV\r\niew your event at https://calendar.google.com/calendar/event?action=VIEW&ei\r\n d=XzYwcTMwYzFnNjBvNzBlMWk2MG80YWMxZzYwcmo4Z3BsODhyajJjMWg4NHMzNGg5ZzYwczMwY\r\nzFnNjBvMzBjMWc2aDBqaWNobTZzcGsyYzFwNnNxNDhlMWc2NG8zMGMxZzYwbzMwYzFnNjBvMzBj\r\n MWc2MG8zMmMxZzYwbzMwYzFnNmQwazJlMjY2a280Y2hpNDY0cmppZTFrNmtzM2FoaGw2NG9qaWR\r\noajcwbzQ4Z3BwOGNyMCAwOTBkZWRiN2JlZWMwNTBhNzAzNWVlNmExMzY1MDc0Y1BpbmJvdW5kLn\r\n Bvc3RtYXJrYXBwLmNvbQ&tok=MTUja2ltaG9hbmdAdHNjLmFpMjE3YjIyZmEwODY2OTU1MWM0Yj\r\nFhYWFjMTM1ZTBiNmM5ODAyZWE3ZQ&ctz=Asia%2FSingapore&hl=en&es=0.\\n-::~:~::~:~:\r\n ~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\r\nLAST-MODIFIED:20220531T013708Z\r\nLOCATION:\r\nSEQUENCE:2\r\nSTATUS:CONFIRMED\r\nSUMMARY:Test Webhook Local\r\nTRANSP:OPAQUE\r\nBEGIN:VALARM\r\nACTION:DISPLAY\r\nDESCRIPTION:This is an event reminder\r\nTRIGGER:-P0DT0H15M0S\r\nEND:VALARM\r\nEND:VEVENT\r\nEND:VCALENDAR\r\n"
      components = ContentLines.from_ical(test_data)
    end
  end
end
