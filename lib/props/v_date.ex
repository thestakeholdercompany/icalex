defmodule ICalendar.Props.VDate do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields() ++ [params: %{value: "DATE"}]

end
