defmodule ICalendar.Props.VBinary do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields() ++
              [params: %{encoding: "BASE64", value: "BINARY"}]
end
