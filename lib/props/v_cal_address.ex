defmodule ICalendar.Props.VCalAddress do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()
end
