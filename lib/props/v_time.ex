defmodule ICalendar.Props.VTime do
  @moduledoc false
  alias ICalendar.Props.Parameters

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields() ++
              [params: %Parameters{parameters: %{value: "TIME"}}]

  defimpl ICal do
    def to_ical(%ICalendar.Props.VTime{value: {hours, minutes, seconds} = _value} = _data),
        do: "#{hours}#{minutes}#{seconds}"
  end
end
