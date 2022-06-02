defmodule ICalex.Parsers.Helpers do
  @moduledoc false
  import String, only: [replace: 3]

  def escape_char(text) do
    replace_semicolon = fn t -> Regex.replace(~r/;/, t, "\\;") end
    replace_comma = fn t -> Regex.replace(~r/,/, t, "\\,") end
    # NOTE: ORDER MATTERS!
    text
    |> replace("\\", "\\\\")
    |> replace_semicolon.()
    |> replace_comma.()
    |> replace("\r\n", "\n")
  end

  def parse_datetime(datetime) when is_bitstring(datetime) do
    regex =
      ~r/(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})T(?<hour>\d{2})(?<minute>\d{2})(?<second>\d{2})(?<tz>\w?)/

    with %{
           "day" => day,
           "hour" => hour,
           "minute" => minute,
           "month" => month,
           "second" => second,
           "tz" => tz,
           "year" => year
         } <- Regex.named_captures(regex, datetime) do
      {year, _} = Integer.parse(year)
      {month, _} = Integer.parse(month)
      {day, _} = Integer.parse(day)
      {hour, _} = Integer.parse(hour)
      {minute, _} = Integer.parse(minute)
      {second, _} = Integer.parse(second)

      if String.downcase(tz) == "z" do
        {:ok,
         %DateTime{
           year: year,
           month: month,
           day: day,
           hour: hour,
           minute: minute,
           second: second,
           utc_offset: 0,
           std_offset: 0,
           zone_abbr: "UTC",
           time_zone: "Etc/UTC"
         }}
      else
        {:ok,
         %NaiveDateTime{
           year: year,
           month: month,
           day: day,
           hour: hour,
           minute: minute,
           second: second
         }}
      end
    else
      _ -> :error
    end
  end

  @doc """
  Given this ical text come from Postmark Inbound webhook for example:

  "BEGIN:VCALENDAR\r\nPRODID:-//Google Inc//Google Calendar 70.9054//EN\r\nVERSION:2.0\r\n
  CALSCALE:GREGORIAN\r\nMETHOD:REQUEST\r\nBEGIN:VEVENT\r\nDTSTART:20220601T043000Z\r\nDTEND:20220601T050000Z\r\n
  DTSTAMP:20220531T013709Z\r\nORGANIZER;CN=kimhoang@tsc.ai:mailto:someone@tsc.ai\r\n
  UID:040000008200E00074C5B7101A82E008000000004A92673A0974D801000000000000000\r\n 0100000003AA8F50FFD17984585F51196380DC9C6\r\n
  ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=\r\n TRUE;CN=12345c@inbound.postmarkapp.com;X-NUM-GUES\r\n
  TS=0:mailto:12345c@inbound.postmarkapp.com\r\nX-MICROSOFT-CDO-OWNERAPPTID:-674825255\r\nCREATED:20220530T093959Z\r\n
  DESCRIPTION:-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~\r\n :~:~:~:~:~:~:~:~::~:~::-\\nDo not edit this section of the description.\\n\\nV\r\n
  iew your event at https://calendar.google.com/calendar/event?action=VIEW&ei\r\n d=XzYwcTMwYzFnNjBvNzBlMWk2MG80YWMxZzYwcmo4Z3BsODhyajJjMWg4NHMzNGg5ZzYwczMwY\r\n
  zFnNjBvMzBjMWc2aDBqaWNobTZzcGsyYzFwNnNxNDhlMWc2NG8zMGMxZzYwbzMwYzFnNjBvMzBj\r\n MWc2MG8zMmMxZzYwbzMwYzFnNmQwazJlMjY2a280Y2hpNDY0cmppZTFrNmtzM2FoaGw2NG9qaWR\r\n
  oajcwbzQ4Z3BwOGNyMCAwOTBkZWRiN2JlZWMwNTBhNzAzNWVlNmExMzY1MDc0Y1BpbmJvdW5kLn\r\n Bvc3RtYXJrYXBwLmNvbQ&tok=MTUja2ltaG9hbmdAdHNjLmFpMjE3YjIyZmEwODY2OTU1MWM0Yj\r\n
  FhYWFjMTM1ZTBiNmM5ODAyZWE3ZQ&ctz=Asia%2FSingapore&hl=en&es=0.\\n-::~:~::~:~:\r\n ~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\r\n
  LAST-MODIFIED:20220531T013708Z\r\nLOCATION:\r\nSEQUENCE:2\r\nSTATUS:CONFIRMED\r\nSUMMARY:Test Webhook Local\r\nTRANSP:OPAQUE\r\nBEGIN:VALARM\r\nACTION:DISPLAY\r\n
  DESCRIPTION:This is an event reminder\r\nTRIGGER:-P0DT0H15M0S\r\nEND:VALARM\r\nEND:VEVENT\r\nEND:VCALENDAR\r\n"

  In the field UID there is a linebreak \r\n:
  UID:040000008200E00074C5B7101A82E008000000004A92673A0974D801000000000000000\r\n 0100000003AA8F50FFD17984585F51196380DC9C6
  Which, when going throught String.split("\r\n") will become a list ["UID:040000008200E00074C5B7101A82E008000000004A92673A0974D801000000000000000",
  " 0100000003AA8F50FFD17984585F51196380DC9C6"]. And when this list go throught parser(nil), the value " 0100000003AA8F50FFD17984585F51196380DC9C6" will
  cause error: (MatchError) no match of right hand side value: [" 0100000003AA8F50FFD17984585F51196380DC9C6"]
  Basically the second value in the list is not a legic ical field, it was created because there is an incorrect linebreak in the original data that cause
  the UID field to be cut into two, with one is still a ablegit field with key - value structure and another one is not.

  This update is to clean up such incorrect linebreaks inside each field.
  """
  def fix_linebreak_in_the_middle_of_value(components) when is_list(components) do
    regex = ~r/^[A-Z-]*[:;][A-Z0-9]*/
    IO.inspect(components)
    fix_linebreak_in_the_middle_of_value(components, [], regex)
  end

  def fix_linebreak_in_the_middle_of_value([head | tail], cleaned_components, regex)
      when is_list(cleaned_components) do
    cleaned_components =
      if String.match?(head, regex) do
        [head | cleaned_components]
      else
        last_added = Enum.at(cleaned_components, 0)
        last_added = last_added <> head
        cleaned_components |> List.delete_at(0) |> List.insert_at(0, last_added)
      end

    fix_linebreak_in_the_middle_of_value(tail, cleaned_components, regex)
  end

  def fix_linebreak_in_the_middle_of_value([], cleaned_components, _)
      when is_list(cleaned_components) do
    Enum.reverse(cleaned_components)
  end
end
