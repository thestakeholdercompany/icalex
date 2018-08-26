defmodule ICalendar.Props.Prop do
  @moduledoc false
  alias ICalendar.Props.Parameters

  def common_fields do
    [value: nil, params: %Parameters{}]
  end
end
