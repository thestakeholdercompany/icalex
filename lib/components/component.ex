defmodule ICalendar.Components.Component do
  @moduledoc false
  alias ICalendar.Props.{Parameters, VText}
  alias ICalendar.Parsers.{ContentLines, ContentLine}

  def is_empty(%{properties: properties, components: components} = _params),
    do: properties === %{} and components === []

  def sorted_keys(component) do
    # TODO: canonical_order
    Map.keys(component.properties)
  end

  def property_items(component, recursive \\ true, sorted \\ true) do
    component_name = ICal.to_ical(%VText{value: component.name})
    properties = [{"BEGIN", component_name}]

    property_names = if sorted, do: sorted_keys(component), else: Map.keys(component.properties)

    properties =
      property_names
      |> Enum.reduce(properties, fn name, acc ->
        values = Map.get(component.properties, name)

        if is_list(values) do
          acc ++ Enum.map(values, fn value -> {name, value} end)
        else
          acc ++ [{name, values}]
        end
      end)

    properties =
      if recursive do
        component.components
        |> Enum.reduce(properties, fn component, acc ->
          acc ++ property_items(component, recursive, sorted)
        end)
      else
        properties
      end

    properties ++ [{"END", component_name}]
  end

  def to_ical(component) do
    component
    |> property_items
    |> Enum.map(fn {name, value} ->
      params =
        if is_map(value) and Map.has_key?(value, :params), do: value.params, else: %Parameters{}

      ContentLine.from_parts(name, params, value, true)
    end)
    |> ContentLines.to_ical()
  end
end
