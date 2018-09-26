defmodule ICalendar.Props.VDuration do
  @moduledoc false
  use ICalendar.Props
  alias Timex.Duration

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(%Duration{} = value), do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    regex = ~r/(?<signal>[+-]?)(?<duration>P.*)/

    with %{"duration" => duration, "signal" => signal} <- Regex.named_captures(regex, value),
         {:ok, duration} <- Duration.parse(duration) do
      duration = if signal == "-", do: Duration.invert(duration), else: duration

      __MODULE__.of(duration)
    else
      _ -> raise ArgumentError, message: "Expected a duration, got: #{value}"
    end
  end

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      result = if Duration.to_seconds(value) < 0, do: "-P", else: "P"
      days = abs(Duration.to_days(value)) |> trunc
      result = if days > 0, do: "#{result}#{days}D", else: result
      hours = (abs(Duration.to_hours(value)) - days * 24) |> trunc
      minutes = (abs(Duration.to_minutes(value)) - (days * 1440 + hours * 60)) |> trunc

      seconds =
        (abs(Duration.to_seconds(value)) - (days * 86400 + hours * 3600 + minutes * 60)) |> trunc

      if hours + minutes + seconds > 0 do
        result = "#{result}T"
        result = if hours > 0, do: "#{result}#{hours}H", else: result
        result = if minutes > 0, do: "#{result}#{minutes}M", else: result
        if seconds > 0, do: "#{result}#{seconds}S", else: result
      else
        result
      end
    end
  end
end
