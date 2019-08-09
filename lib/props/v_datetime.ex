defmodule ICalex.Props.VDatetime do
  @moduledoc false
  use ICalex.Props
  alias ICalex.Parsers.Helpers

  @enforce_keys [:value]
  defstruct ICalex.Props.common_fields()

  def format_date(year, month, day, hour, minute, second) do
    format = fn n -> n |> Integer.to_string() |> String.pad_leading(2, "0") end
    "#{year}#{format.(month)}#{format.(day)}T#{format.(hour)}#{format.(minute)}#{format.(second)}"
  end

  def of(%DateTime{} = value), do: %__MODULE__{value: value}
  def of(%NaiveDateTime{} = value), do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    with {:ok, datetime} <- Helpers.parse_datetime(value) do
      __MODULE__.of(datetime)
    else
      _ -> raise ArgumentError, message: ~s(Expected a date time, got: #{value})
    end
  end

  def to_ical(%{value: %NaiveDateTime{} = value} = _data) do
    %NaiveDateTime{
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second
    } = value

    format_date(year, month, day, hour, minute, second)
  end

  defimpl ICal do
    def to_ical(%{value: %DateTime{zone_abbr: zone_abbr} = value} = _data) do
      ts =
        value
        |> DateTime.to_naive()
        |> ICalex.Props.VDatetime.of()
        |> ICalex.Props.VDatetime.to_ical()

      if zone_abbr == "UTC" do
        ts <> "Z"
      else
        ts
      end
    end

    def to_ical(%{value: %NaiveDateTime{} = _value} = data) do
      ICalex.Props.VDatetime.to_ical(data)
    end
  end
end
