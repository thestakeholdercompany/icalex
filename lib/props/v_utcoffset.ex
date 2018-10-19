defmodule ICalendar.Props.VUTCOffset do
  @moduledoc false
  use ICalendar.Props
  alias Timex.Duration

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(%Duration{} = value), do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    value_regex = ~r/(?<signal>[+-]?)(?<offset>\d+)/
    offset_regex = ~r/(?<days>\d{2})?(?<hours>\d{2})(?<minutes>\d{2})/

    with %{"offset" => offset, "signal" => signal} <- Regex.named_captures(value_regex, value),
         %{"days" => days, "hours" => hours, "minutes" => minutes} <-
           Regex.named_captures(offset_regex, offset) do
      days = parse_time_unit(days)
      hours = parse_time_unit(hours)
      minutes = parse_time_unit(minutes)

      duration =
        Timex.Duration.zero()
        |> Timex.Duration.add(Timex.Duration.from_days(days))
        |> Timex.Duration.add(Timex.Duration.from_hours(hours))
        |> Timex.Duration.add(Timex.Duration.from_minutes(minutes))

      duration = if signal == "-", do: Duration.invert(duration), else: duration
      __MODULE__.of(duration)
    else
      _ -> raise ArgumentError, message: ~s(Expected a date, got: #{value})
    end
  end

  defimpl ICal do
    defp format_time_unit(time_unit),
      do: Integer.to_string(time_unit) |> String.pad_leading(2, "0")

    def to_ical(%{value: value} = _data) do
      total_seconds = Duration.to_seconds(value)
      sign = if total_seconds >= 0, do: "+", else: "-"
      hours = abs(Duration.to_hours(value)) |> trunc
      minutes = (abs(Duration.to_minutes(value)) - hours * 60) |> trunc
      seconds = (abs(total_seconds) - (hours * 3600 + minutes * 60)) |> trunc

      result = "#{sign}#{format_time_unit(hours)}#{format_time_unit(minutes)}"

      cond do
        seconds > 0 -> "#{result}#{format_time_unit(seconds)}"
        true -> result
      end
    end
  end

  defp parse_time_unit(time_unit) do
    with {time_unit, _} <- Integer.parse(time_unit) do
      time_unit
    else
      _ -> 0
    end
  end
end
