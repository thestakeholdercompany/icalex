defmodule ICalendar.Parsers.Helpers do
  @moduledoc false
  import String, only: [replace: 3]

  def escape_char(text) do
    replace_semicolon = fn t -> Regex.replace(~r/;/, t, "\\;") end
    replace_comma = fn t -> Regex.replace(~r/,/, t, "\\,") end
    # NOTE: ORDER MATTERS!
    text
    |> replace("\\", "\\\\")
    |> replace_semicolon.()
    |> replace_comma.()
    |> replace("\r\n", "\n")
  end
end
