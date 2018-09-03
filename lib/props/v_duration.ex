defmodule ICalendar.Props.VDuration do
  @moduledoc false
  use ICalendar.Props
  alias Timex.Duration

  # TODO VDuration implementation

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(%Duration{} = value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      alias ICalendar.Props.VDuration
      {hours, minutes, seconds, _} = Duration.to_clock value
      result = if (Duration.to_milliseconds value) < 0, do: "-P", else: "P"
      days = hours / 24 |> round() |> abs()
      result = if days > 0, do: "#{result}#{days}D", else: result
      hours = abs(hours) - (days * 24)
      minutes = abs(minutes)
      seconds = abs(seconds)
      if (hours + minutes + seconds) > 0 do
        result = result <> "T"
        result = if hours > 0, do: "#{result}#{days}H", else: result
        result = if minutes > 0, do: "#{result}#{days}M", else: result
        result = if seconds > 0, do: "#{result}#{days}S", else: result
      else
        result
      end
    end
  end
end
