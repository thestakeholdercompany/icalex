defmodule ICalex.Parsers.ContentLines do
  @moduledoc false

  alias ICalex.Parsers.ContentLine
  alias ICalex.Components.Factory, as: ComponentsFactory
  alias ICalex.Props.Factory, as: PropsFactory
  alias ICalex.Components.Component
  alias ICalex.Parsers.Helpers

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
      |> Helpers.fix_linebreak_in_the_middle_of_value()  # Attachements come from Postmark have this issue
      |> parser(nil)

    component
  end

  defp parser([line | lines], component) do
    case ContentLine.parts(line) do
      {"begin", _parameters, value} when is_nil(component) ->
        component = ComponentsFactory.get_component(value)
        parser(lines, component)

      {"begin", _parameters, value} ->
        {lines, c} = parser(lines, ComponentsFactory.get_component(value))

        component =
          component
          |> Component.add_component(c)

        parser(lines, component)

      {"end", _parameters, _value} ->
        {lines, component}

      {property, parameters, value} ->
        type =
          PropsFactory.from_ical(property, value)
          |> Map.put(:params, parameters)

        component =
          component
          |> Component.add(property, type, parameters)

        parser(lines, component)
    end
  end

  defp parser([], component), do: {[], component}
end
