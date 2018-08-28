defmodule ICalendar.Props.VText do
  @moduledoc false

  @enforce_keys [:value]
  defstruct ICalendar.Props.Prop.common_fields()

  defimpl ICal do
    def to_ical(%ICalendar.Props.VText{value: value} = _data) when is_bitstring(value) do
      alias ICalendar.Parsers.Helpers
      Helpers.escape_char(value)
    end
  end
end
