defmodule ICalendar.Parsers.ContentLine do
  @moduledoc false

  alias ICalendar.Props.VText

  # TODO: create a Parameters struct?
  def from_parts(name, %{} = params, value, sorted \\ true) do
    value =
      case ICal.impl_for(value) do
        nil -> ICal.to_ical(%VText{value: value})
        _ -> ICal.to_ical(value)
      end

    if params == %{} do
      "#{name}:#{value}"
    else
      regex = Regex.compile!("[,;: ’']")

      sanitize_value = fn value ->
        if Regex.match?(regex, value), do: ~s("#{value}"), else: value
      end

      keys = Map.keys(params)
      keys = if sorted, do: Enum.sort(keys), else: keys

      params =
        keys
        |> Enum.map(fn key -> "#{String.upcase(key)}=#{sanitize_value.(params[key])}" end)
        |> Enum.join(";")

      "#{name};#{params}:#{value}"
    end
  end

  def to_ical(content_line, limit \\ 75, separator \\ "\r\n ") do
    #    assert '\n' not in line
    limit = limit - 1
    fold_line(String.split_at(content_line, limit), "", limit, separator)
  end

  defp fold_line({head, ""}, result, _, _), do: result <> head

  defp fold_line({head, tail}, result, limit, separator) do
    fold_line(String.split_at(tail, limit), result <> head <> separator, limit, separator)
  end
end
