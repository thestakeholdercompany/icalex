defmodule ICalendar.Props.VDate do
  @moduledoc false
  use ICalendar.Props.Prop
  alias ICalendar.Props.Parameters

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields() ++
              [params: %Parameters{parameters: %{value: "DATE"}}]

  def of(%Date{} = value), do: %__MODULE__{value: value}

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      %Date{year: year, month: month, day: day} = value
      format = fn n -> n |> Integer.to_string() |> String.pad_leading(2, "0") end
      "#{year}#{format.(month)}#{format.(day)}"
    end
  end
end
