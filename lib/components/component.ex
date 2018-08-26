defmodule ICalendar.Components.Component do
  @moduledoc false
  alias ICalendar.Props.{Parameters, VText}
  alias ICalendar.Parsers.{ContentLines, ContentLine}

  def property_items(component) do
    # vText = types_factory['text']
    # properties = [('BEGIN', vText(self.name).to_ical())]
    # properties.append(('END', vText(self.name).to_ical()))
    component_name = ICal.to_ical(%VText{value: component.name})
    properties = [{"BEGIN", component_name}]
    properties = properties ++ [{"END", component_name}]
    properties
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
