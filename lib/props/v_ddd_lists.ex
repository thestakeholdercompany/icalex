defmodule ICalendar.Props.VDDDLists do
  @moduledoc false
  use ICalendar.Props

  # TODO VDDDLists implementation

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      value
    end
  end
end
