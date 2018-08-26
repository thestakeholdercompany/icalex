defmodule ICalendar.Props.VInt do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  def to_ical(%ICalendar.Props.VInt{value: value} = _data) when is_integer(value),
    do: Integer.to_string(value)
end
