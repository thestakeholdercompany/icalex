defmodule ICalendar.Props do
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

      defimpl Property do
        def of(value), do: __MODULE__.of(value)
        def of(value, params), do: __MODULE__.of(value, params)
      end
    end
  end

  def is_prop(prop), do: unless(Property.impl_for(prop), do: false, else: true)
end
