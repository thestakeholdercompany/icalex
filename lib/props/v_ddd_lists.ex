defmodule ICalex.Props.VDDDLists do
  @moduledoc false
  use ICalex.Props
  alias ICalex.Props.VDDDTypes

  @enforce_keys [:value]
  defstruct ICalex.Props.common_fields()

  # TODO where TZID is used in library
  def of(value) when is_list(value) do
    values = for v <- value, do: VDDDTypes.of(v)
    %__MODULE__{value: values}
  end

  def of(%DateTime{} = value), do: %__MODULE__{value: [VDDDTypes.of(value)]}

  def from(value) when is_bitstring(value) do
    value |> String.split(",") |> Enum.map(&VDDDTypes.from/1)
  end

  defimpl ICal do
    def to_ical(%{value: value} = _data) do
      value |> Enum.map(&ICal.to_ical(&1)) |> Enum.join(",")
    end
  end
end
