defmodule ICalendar.Parsers.ContentLines do
  @moduledoc false

  alias ICalendar.Parsers.ContentLine

  def to_ical(content_lines) when is_list(content_lines) do
    content_lines = for line <- content_lines, line != "", do: ContentLine.to_ical(line)

    content_lines =
      content_lines
      |> Enum.join("\r\n")

    content_lines <> "\r\n"
  end

  def from_ical(value) when is_bitstring(value) do
    value
    |> String.split()
    |> Enum.map(fn line ->
      {name, parameters, value} = ContentLine.parts(line)
    end)
    # TODO continue parser engine from here
  end

end
