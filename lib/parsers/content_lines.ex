defmodule ICalendar.Parsers.ContentLines do
  @moduledoc false

  alias ICalendar.Parsers.ContentLine
  alias ICalendar.Components.Factory, as: ComponentsFactory
  alias ICalendar.Props.Factory, as: PropsFactory
  alias ICalendar.Components.Component

  def to_ical(content_lines) when is_list(content_lines) do
    content_lines = for line <- content_lines, line != "", do: ContentLine.to_ical(line)

    content_lines =
      content_lines
      |> Enum.join("\r\n")

    content_lines <> "\r\n"
  end

  def from_ical(value) when is_bitstring(value) do
    {[], component} =
      value
      |> String.split("\r\n")
      |> parser(nil)

    component
  end

  defp parser([line | lines], component) do
    case ContentLine.parts(line) do
      {"begin", parameters, value} when is_nil(component) ->
        component = ComponentsFactory.get_component(value, parameters)
        parser(lines, component)

      {"begin", parameters, value} ->
        {lines, c} = parser(lines, ComponentsFactory.get_component(value, parameters))

        component =
          component
          |> Component.add_component(c)

        parser(lines, component)

      {"end", parameters, value} ->
        {lines, component}

      {property, parameters, value} ->
        type_name = PropsFactory.get_type_name(property)
        # TODO parameter?
        type = PropsFactory.from_ical(type_name, value)

        component =
          component
          |> Component.add(type_name, type)

        parser(lines, component)
    end
  end

  defp parser([], component), do: {[], component}
end
