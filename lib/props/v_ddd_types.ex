defmodule ICalendar.Props.VDDDTypes do
  @moduledoc false
  use ICalendar.Props
  alias Timex.Duration

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(%Date{} = value), do: %__MODULE__{value: value}
  def of(%DateTime{} = value), do: %__MODULE__{value: value}
  def of(%NaiveDateTime{} = value), do: %__MODULE__{value: value}
  def of({_hours, _minutes, _seconds} = value), do: %__MODULE__{value: value}
  def of(%Duration{} = value), do: %__MODULE__{value: value}

  def of({%DateTime{} = _start_duration, %DateTime{} = _end_duration} = value),
    do: %__MODULE__{value: value}

  def of({%NaiveDateTime{} = _start_duration, %NaiveDateTime{} = _end_duration} = value),
    do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    value_length = String.length(value)

    cond do
      String.starts_with?(value, ["P", "-P", "+P"]) -> ICalendar.Props.VDuration.from(value)
      String.contains?(value, "/") -> ICalendar.Props.VPeriod.from(value)
      value_length == 6 -> ICalendar.Props.VTime.from(value)
      value_length == 8 -> ICalendar.Props.VDate.from(value)
      value_length in [15, 16] -> ICalendar.Props.VDatetime.from(value)
      true -> raise ArgumentError, message: ~s(Expected a date time, got: #{value})
    end
  end

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      case value do
        %DateTime{} ->
          ICal.to_ical(ICalendar.Props.VDatetime.of(value))

        %NaiveDateTime{} ->
          ICal.to_ical(ICalendar.Props.VDatetime.of(value))

        %Date{} ->
          ICal.to_ical(ICalendar.Props.VDate.of(value))

        {_hours, _minutes, _seconds} ->
          ICal.to_ical(ICalendar.Props.VTime.of(value))

        %Duration{} ->
          ICal.to_ical(ICalendar.Props.VDuration.of(value))

        {%DateTime{}, %DateTime{}} ->
          ICal.to_ical(ICalendar.Props.VPeriod.of(value))

        {%NaiveDateTime{}, %NaiveDateTime{}} ->
          ICal.to_ical(ICalendar.Props.VPeriod.of(value))
      end
    end
  end
end
