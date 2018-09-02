defmodule ICalendar.Props.VPeriod do
  @moduledoc false
  use ICalendar.Props
  alias ICalendar.Props.VDatetime

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  # TODO accept timedelta?

  def of({%DateTime{} = start_duration, %DateTime{} = end_duration} = value), do: %__MODULE__{value: value}
  def of({%NaiveDateTime{} = start_duration, %NaiveDateTime{} = end_duration} = value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: {start_duration, end_duration} = value} = _data) do
      "#{ICal.to_ical(VDatetime.of(start_duration))}/#{ICal.to_ical(VDatetime.of(end_duration))}"
    end
  end
end
