defmodule ICalendar.Props.VGeo do
  @moduledoc false
  use ICalendar.Props

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of({_lat, _lon} = value), do: %__MODULE__{value: value}
  def of([lat, lon] = _value), do: %__MODULE__{value: {lat, lon}}

  def from(value) when is_bitstring(value) do
    with [lat, lon] <- String.split(value, ";"),
         {lat, _} = Float.parse(lat),
         {lon, _} = Float.parse(lon) do
      __MODULE__.of({lat, lon})
    else
      _ -> raise ArgumentError, message: ~s(Expected a "latitude;longitude", got: #{value})
    end
  end

  defimpl ICal do
    def to_ical(%{value: {lat, lon} = _value} = _data), do: "#{lat};#{lon}"
  end
end
