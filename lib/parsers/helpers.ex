defmodule ICalendar.Parsers.Helpers do
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
end
