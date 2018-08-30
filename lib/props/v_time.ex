defmodule ICalendar.Props.VTime do
  @moduledoc false
  use ICalendar.Props
  alias ICalendar.Props.Parameters

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields() ++ [params: %Parameters{parameters: %{value: "TIME"}}]

  def of({_hours, _minutes, _seconds} = value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: {hours, minutes, seconds} = _value} = _data),
      do: "#{hours}#{minutes}#{seconds}"
  end
end
