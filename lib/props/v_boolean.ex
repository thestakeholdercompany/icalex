defmodule ICalendar.Props.VBoolean do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  defimpl ICal do
    def to_ical(%ICalendar.Props.VBoolean{value: value} = _data),
      do: if(value, do: "TRUE", else: "FALSE")
  end
end
