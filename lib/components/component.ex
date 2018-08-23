defmodule ICalendar.Components.Component do
  @moduledoc false
  alias ICalendar.Props.VText
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
      # get the params from the value
      # params = getattr(value, 'params', Parameters())
      # Contentline.from_parts(name, params, value, sorted=sorted)
      ContentLine.from_parts(name, %{}, value, true)
    end)
    |> ContentLines.to_ical()
  end
end
