defmodule ICalendar.Props.VGeo do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  defimpl ICal do
    def to_ical(%ICalendar.Props.VGeo{value: {lat, lon} = _value} = _data), do: "#{lat};#{lon}"
  end
end
