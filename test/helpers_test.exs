defmodule ICalexTest.Helpers do
  use ExUnit.Case
  doctest ICalex

  alias ICalex.Parsers.Helpers

  test "fix_linebreak_in_the_middle_of_value" do
    regex = ~r/^[A-Z-]*[:;][A-Z0-9]*/

    test_data =
      "BEGIN:VCALENDAR\r\nPRODID:-//Google Inc//Google Calendar 70.9054//EN\r\nVERSION:2.0\r\nCALSCALE:GREGORIAN\r\nMETHOD:REQUEST\r\nBEGIN:VEVENT\r\nDTSTART:20220601T043000Z\r\nDTEND:20220601T050000Z\r\nDTSTAMP:20220531T013709Z\r\nORGANIZER;CN=kimhoang@tsc.ai:mailto:someone@tsc.ai\r\nUID:040000008200E00074C5B7101A82E008000000004A92673A0974D801000000000000000\r\n 0100000003AA8F50FFD17984585F51196380DC9C6\r\nATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=\r\n TRUE;CN=12345c@inbound.postmarkapp.com;X-NUM-GUES\r\nTS=0:mailto:12345c@inbound.postmarkapp.com\r\nX-MICROSOFT-CDO-OWNERAPPTID:-674825255\r\nCREATED:20220530T093959Z\r\nDESCRIPTION:-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~\r\n :~:~:~:~:~:~:~:~::~:~::-\\nDo not edit this section of the description.\\n\\nV\r\niew your event at https://calendar.google.com/calendar/event?action=VIEW&ei\r\n d=XzYwcTMwYzFnNjBvNzBlMWk2MG80YWMxZzYwcmo4Z3BsODhyajJjMWg4NHMzNGg5ZzYwczMwY\r\nzFnNjBvMzBjMWc2aDBqaWNobTZzcGsyYzFwNnNxNDhlMWc2NG8zMGMxZzYwbzMwYzFnNjBvMzBj\r\n MWc2MG8zMmMxZzYwbzMwYzFnNmQwazJlMjY2a280Y2hpNDY0cmppZTFrNmtzM2FoaGw2NG9qaWR\r\noajcwbzQ4Z3BwOGNyMCAwOTBkZWRiN2JlZWMwNTBhNzAzNWVlNmExMzY1MDc0Y1BpbmJvdW5kLn\r\n Bvc3RtYXJrYXBwLmNvbQ&tok=MTUja2ltaG9hbmdAdHNjLmFpMjE3YjIyZmEwODY2OTU1MWM0Yj\r\nFhYWFjMTM1ZTBiNmM5ODAyZWE3ZQ&ctz=Asia%2FSingapore&hl=en&es=0.\\n-::~:~::~:~:\r\n ~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\r\nLAST-MODIFIED:20220531T013708Z\r\nLOCATION:\r\nSEQUENCE:2\r\nSTATUS:CONFIRMED\r\nSUMMARY:Test Webhook Local\r\nTRANSP:OPAQUE\r\nBEGIN:VALARM\r\nACTION:DISPLAY\r\nDESCRIPTION:This is an event reminder\r\nTRIGGER:-P0DT0H15M0S\r\nEND:VALARM\r\nEND:VEVENT\r\nEND:VCALENDAR\r\n"

    cleaned_list =
      test_data |> String.split("\r\n") |> Helpers.fix_linebreak_in_the_middle_of_value()

    # Expect all elements are in key - value structure
    assert Enum.all?(cleaned_list, fn x -> String.match?(x, regex) end)
  end
end
