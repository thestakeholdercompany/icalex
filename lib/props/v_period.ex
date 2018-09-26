defmodule ICalendar.Props.VPeriod do
  @moduledoc false
  use ICalendar.Props
  alias ICalendar.Props.{VDDDTypes, VDuration}
  alias ICalendar.Parsers.Helpers
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

  def from(value) when is_bitstring(value) do
    with [start_duration, end_duration] <- String.split(value, "/") do
      {:ok, start_duration} = Helpers.parse_datetime(start_duration)

      {:ok, end_duration} =
        if String.downcase(end_duration) =~ "p" do
          Duration.parse(end_duration)
        else
          Helpers.parse_datetime(end_duration)
        end

      __MODULE__.of({start_duration, end_duration})
    else
      _ -> raise ArgumentError, message: "Expected a period, got: #{value}"
    end
  end

  defimpl ICal do
    def to_ical(%{value: {start_duration, %Duration{} = end_duration} = _value} = _data) do
      "#{ICal.to_ical(VDDDTypes.of(start_duration))}/#{ICal.to_ical(VDuration.of(end_duration))}"
    end

    def to_ical(%{value: {start_duration, end_duration} = _value} = _data) do
      "#{ICal.to_ical(VDDDTypes.of(start_duration))}/#{ICal.to_ical(VDDDTypes.of(end_duration))}"
    end
  end
end
