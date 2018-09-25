defmodule ICalendar.Props.VDate do
  @moduledoc false
  use ICalendar.Props
  alias ICalendar.Props.Parameters

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields() ++ [params: %Parameters{parameters: %{value: "DATE"}}]

  def of(%Date{} = value), do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    with {:ok, datetime} <- Timex.parse(value, "{YYYY}{M}{D}") do
      __MODULE__.of(Timex.to_date(datetime))
    else
      _ -> raise ArgumentError, message: ~s(Expected a date, got: #{value})
    end
  end

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      %Date{year: year, month: month, day: day} = value
      format = fn n -> n |> Integer.to_string() |> String.pad_leading(2, "0") end
      "#{year}#{format.(month)}#{format.(day)}"
    end
  end
end
