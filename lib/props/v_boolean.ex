defmodule ICalendar.Props.VBoolean do
  @moduledoc false
  use ICalendar.Props.Prop
  alias ICalendar.Props.Parameters

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  def of(value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data),
      do: if(value, do: "TRUE", else: "FALSE")
  end
end
