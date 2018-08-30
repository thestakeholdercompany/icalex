defmodule ICalendar.Parsers.ContentLine do
  @moduledoc false

  alias ICalendar.Props.{Parameters, VText}

  def from_parts(name, %Parameters{} = params, value, sorted \\ true) do
    value =
      case ICal.impl_for(value) do
        nil -> ICal.to_ical(%VText{value: value})
        _ -> ICal.to_ical(value)
      end

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
