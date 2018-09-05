defmodule ICalendar.Props.VPeriod do
  @moduledoc false
  use ICalendar.Props
  alias ICalendar.Props.{VDDDTypes, VDuration}
  alias Timex.Duration

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of({%DateTime{} = _start_duration, %DateTime{} = _end_duration} = value),
    do: %__MODULE__{value: value}

  def of({%DateTime{} = _start_duration, %Duration{} = _end_duration} = value),
    do: %__MODULE__{value: value}

  def of({%NaiveDateTime{} = _start_duration, %NaiveDateTime{} = _end_duration} = value),
    do: %__MODULE__{value: value}

  def of({%NaiveDateTime{} = _start_duration, %Duration{} = _end_duration} = value),
    do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: {start_duration, %Duration{} = end_duration} = _value} = _data) do
      "#{ICal.to_ical(VDDDTypes.of(start_duration))}/#{ICal.to_ical(VDuration.of(end_duration))}"
    end

    def to_ical(%{value: {start_duration, end_duration} = _value} = _data) do
      "#{ICal.to_ical(VDDDTypes.of(start_duration))}/#{ICal.to_ical(VDDDTypes.of(end_duration))}"
    end
  end
end
