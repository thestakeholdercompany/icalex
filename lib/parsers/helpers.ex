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

  def fix_linebreak_in_the_middle_of_value(components) when is_list(components) do
    regex = ~r/^[A-Z-]*[:;][A-Z0-9]*/
    fix_linebreak_in_the_middle_of_value(components, [], regex)
  end

  def fix_linebreak_in_the_middle_of_value([head | tail], cleaned_components, regex) when is_list(cleaned_components) do
    cleaned_components = if String.match?(head, regex) do
      [head | cleaned_components]
    else
      last_added = Enum.at(cleaned_components, 0)
      last_added = last_added <> head
      cleaned_components |> List.delete_at(0) |> List.insert_at(0, last_added)
    end
    fix_linebreak_in_the_middle_of_value(tail, cleaned_components, regex)
  end

  def fix_linebreak_in_the_middle_of_value([], cleaned_components, _) when is_list(cleaned_components) do
    Enum.reverse(cleaned_components)
  end
end
