defmodule ICalendar.Props.VUri do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  defimpl ICal do
    def to_ical(%ICalendar.Props.VUri{value: value} = _data) when is_bitstring(value),
      do: value
  end
end
