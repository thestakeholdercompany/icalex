defmodule ICalendar.Props.Prop do
  @moduledoc false
  alias ICalendar.Props.Parameters

  def common_fields do
    [value: nil, params: %Parameters{}]
  end

  @doc false
  defmacro __using__(_opts) do
    quote do
      def of(value, %Parameters{} = params),
        do: Map.put(__MODULE__.of(value), :params, params)
    end
  end
end
