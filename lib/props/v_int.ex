defmodule ICalendar.Props.VInt do
  @moduledoc false
  use ICalendar.Props

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(value) when is_integer(value), do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    case Integer.parse(value) do
      {value, ""} -> __MODULE__.of(value)
      _ -> raise ArgumentError, message: ~s(Expected an int, got: #{value})
    end
  end

  defimpl ICal do
    def to_ical(%{value: value} = _data), do: Integer.to_string(value)
  end
end
