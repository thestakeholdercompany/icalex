defmodule ICalendar.Props.VBoolean do
  @moduledoc false
  use ICalendar.Props

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(value), do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    case String.downcase(value) do
      "true" -> __MODULE__.of(true)
      "false" -> __MODULE__.of(false)
      _ -> raise ArgumentError, message: ~s(Expected "true" or "false", got: #{value})
    end
  end

  defimpl ICal do
    def to_ical(%{value: value} = _data),
      do: if(value, do: "TRUE", else: "FALSE")
  end
end
