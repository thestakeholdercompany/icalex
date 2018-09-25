defmodule ICalendar.Props.VText do
  @moduledoc false
  use ICalendar.Props

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(value) when is_bitstring(value), do: %__MODULE__{value: value}
  # TODO encode value?
  def from(value) when is_bitstring(value), do: __MODULE__.of(value)

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      alias ICalendar.Parsers.Helpers
      Helpers.escape_char(value)
    end
  end
end
