defmodule ICalendar.Props.VTime do
  @moduledoc false
  use ICalendar.Props
  alias ICalendar.Props.Parameters

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields() ++ [params: %Parameters{parameters: %{value: "TIME"}}]

  def of({hour, minute, second}),
    do: %__MODULE__{value: %Time{hour: hour, minute: minute, second: second}}

  def of(%Time{} = value), do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    regex = ~r/(?<hour>\d{2})(?<minute>\d{2})(?<second>\d{2})/

    with %{"hour" => hour, "minute" => minute, "second" => second} <-
           Regex.named_captures(regex, value) do
      {hour, _} = Integer.parse(hour)
      {minute, _} = Integer.parse(minute)
      {second, _} = Integer.parse(second)
      {:ok, value} = Time.new(hour, minute, second)
      __MODULE__.of(value)
    else
      _ -> raise ArgumentError, message: ~s(Expected a time, got: #{value})
    end
  end

  defimpl ICal do
    def to_ical(%{value: %Time{hour: hour, minute: minute, second: second} = _value} = _data) do
      "#{hour}#{minute}#{second}"
    end
  end
end
