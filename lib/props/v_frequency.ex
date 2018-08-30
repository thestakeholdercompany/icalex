defmodule ICalendar.Props.VFrequency do
  @moduledoc false
  use ICalendar.Props.Prop

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  def of(value) when is_bitstring(value) do
    value = String.downcase(value)

    if value not in ["secondly", "minutely", "hourly", "daily", "weekly", "monthly", "yearly"] do
      raise ArgumentError, message: "Expected frequency, got: #{value}"
    else
      %__MODULE__{value: String.upcase(value)}
    end
  end

  defimpl ICal do
    def to_ical(%{value: value} = _data), do: value
  end
end
