defmodule ICalendar.Props.VDatetime do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  def format_date(year, month, day, hour, minute, second) do
    format = fn n -> n |> Integer.to_string() |> String.pad_leading(2, "0") end
    "#{year}#{format.(month)}#{format.(day)}T#{format.(hour)}#{format.(minute)}#{format.(second)}"
  end

  def to_ical(%ICalendar.Props.VDatetime{value: %DateTime{} = value} = _data) do
    %DateTime{
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      zone_abbr: zone_abbr
    } = value

    ts = format_date(year, month, day, hour, minute, second)

    if zone_abbr == "UTC" do
      ts <> "Z"
    else
      ts
    end
  end

  def to_ical(%ICalendar.Props.VDatetime{value: %NaiveDateTime{} = value} = _data) do
    %NaiveDateTime{year: year, month: month, day: day, hour: hour, minute: minute, second: second} =
      value

    format_date(year, month, day, hour, minute, second)
  end
end
