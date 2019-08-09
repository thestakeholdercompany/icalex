defmodule ICalex.Props.VCalAddress do
  @moduledoc false
  use ICalex.Props

  @enforce_keys [:value]
  defstruct ICalex.Props.common_fields()

  def of(value) when is_bitstring(value), do: %__MODULE__{value: value}
  def from(value) when is_bitstring(value), do: __MODULE__.of(value)

  defimpl ICal do
    def to_ical(%{value: value} = _data),
      do: value
  end
end
