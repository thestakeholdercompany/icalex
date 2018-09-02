defmodule ICalendar.Props.VDuration do
  @moduledoc false
  use ICalendar.Props
  alias Timex.Duration

  # TODO VDuration implementation

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(%Duration{} = value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      value
    end
  end
end
