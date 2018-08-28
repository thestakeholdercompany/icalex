defmodule ICalendar.Props.VDDDTypes do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  defimpl ICal do
    def to_ical(%ICalendar.Props.VDDDTypes{value: value} = _data) do
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
