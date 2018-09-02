defmodule ICalendar.Props.VUTCOffset do
  @moduledoc false
  use ICalendar.Props

  # TODO VUTCOffset implementation

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      value
    end
  end
end
