defmodule ICalendar.Props.VBinary do
  @moduledoc false
  use ICalendar.Props
  alias ICalendar.Props.Parameters

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields() ++
              [params: %Parameters{parameters: %{encoding: "BASE64", value: "BINARY"}}]

  def of(value) when is_bitstring(value), do: %__MODULE__{value: value}

  def from(value) when is_bitstring(value) do
    with {:ok, value} <- Base.decode64(value) do
      __MODULE__.of(value)
    else
      _ -> raise ArgumentError, message: ~s(Expected a base 64 encoding, got: #{value})
    end
  end

  defimpl ICal do
    def to_ical(%{value: value} = _data),
      do: Base.encode64(value)
  end
end
