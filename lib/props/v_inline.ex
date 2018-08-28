defmodule ICalendar.Props.VInline do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  defimpl ICal do
    def to_ical(%ICalendar.Props.VInline{value: value} = _data) when is_bitstring(value),
      do: value
  end
end
