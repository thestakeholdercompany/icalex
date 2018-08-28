defmodule ICalendar.Props.VFloat do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  defimpl ICal do
    def to_ical(%ICalendar.Props.VFloat{value: value} = _data) when is_float(value),
      do: Float.to_string(value)
  end
end
