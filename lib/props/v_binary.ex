defmodule ICalendar.Props.VBinary do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields() ++
              [params: %{encoding: "BASE64", value: "BINARY"}]

  def to_ical(%ICalendar.Props.VBinary{value: value} = _data) when is_bitstring(value),
    do: Base.encode64(value)
end
