defmodule ICalendar.Props.VUTCOffset do
  @moduledoc false
  use ICalendar.Props
  alias Timex.Duration

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(%Duration{} = value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      total_seconds = Duration.to_seconds(value)
      sign = if total_seconds >= 0, do: "+", else: "-"
      hours = abs(Duration.to_hours(value)) |> trunc
      minutes = (abs(Duration.to_minutes(value)) - hours * 60) |> trunc
      seconds = (abs(total_seconds) - (hours * 3600 + minutes * 60)) |> trunc
      format = fn n -> n |> Integer.to_string() |> String.pad_leading(2, "0") end

      result = "#{sign}#{format.(hours)}#{format.(minutes)}"

      cond do
        seconds > 0 -> "#{result}#{format.(seconds)}"
        true -> result
      end
    end
  end
end
