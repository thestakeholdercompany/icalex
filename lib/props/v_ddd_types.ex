defmodule ICalendar.Props.VDDDTypes do
  @moduledoc false
  use ICalendar.Props.Prop

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  def of(%Date{} = value), do: %__MODULE__{value: value}
  def of(%DateTime{} = value), do: %__MODULE__{value: value}
  def of(%NaiveDateTime{} = value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      cond do
        %DateTime{} = value ->
          ICal.to_ical(%ICalendar.Props.VDatetime{value: value})

        %NaiveDateTime{} = value ->
          ICal.to_ical(%ICalendar.Props.VDatetime{value: value})

        %Date{} = value ->
          ICal.to_ical(%ICalendar.Props.VDate{value: value})
          # TODO: add VDuration, VTime and VPeriod
      end
    end
  end
end
