defmodule ICalendar.Props.VCalAddress do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  def to_ical(%ICalendar.Props.VCalAddress{value: value} = _data) when is_bitstring(value),
    do: value
end
