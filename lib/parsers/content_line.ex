defmodule ICalex.Parsers.ContentLine do
  @moduledoc false

  alias ICalex.Props.{Parameters, VText}

  def parts(line) when is_bitstring(line) do
    [name_parameters, value] = String.split(line, ":", parts: 2)
    [name | parameters] = String.split(name_parameters, ";")

    parameters =
      Enum.reduce(parameters, %{}, fn parameter, acc ->
        [key, value] = String.split(parameter, "=")
        Map.put(acc, String.downcase(key), value)
      end)

    {String.downcase(name), %Parameters{parameters: parameters}, value}
  end

  def from_parts(name, %Parameters{} = params, value, sorted \\ true) do
    value =
      if ICalex.Props.is_prop(value),
        do: ICal.to_ical(value),
        else: ICal.to_ical(%VText{value: value})

    if Parameters.is_empty(params) do
      "#{name}:#{value}"
    else
      "#{name};#{Parameters.to_ical(params, sorted)}:#{value}"
    end
  end

  def to_ical(content_line, limit \\ 75, separator \\ "\r\n ") do
    if String.contains?(content_line, "\n"),
      do:
        raise(
          ArgumentError,
          message: "Content line can not contain unescaped new line characters."
        )

    limit = limit - 1
    fold_line(String.split_at(content_line, limit), "", limit, separator)
  end

  defp fold_line({head, ""}, result, _, _), do: result <> head

  defp fold_line({head, tail}, result, limit, separator) do
    fold_line(String.split_at(tail, limit), result <> head <> separator, limit, separator)
  end
end
