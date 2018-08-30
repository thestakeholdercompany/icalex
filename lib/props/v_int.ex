defmodule ICalendar.Props.VInt do
  @moduledoc false
  use ICalendar.Props.Prop

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  def of(value) when is_integer(value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data), do: Integer.to_string(value)
  end
end
