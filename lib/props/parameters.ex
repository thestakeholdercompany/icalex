defmodule ICalendar.Props.Parameters do
  @moduledoc false
  defstruct parameters: %{}

  def is_empty(%ICalendar.Props.Parameters{parameters: parameters} = _params),
    do: parameters === %{}

  def to_ical(%ICalendar.Props.Parameters{parameters: parameters} = _params, sorted \\ true) do
    regex = Regex.compile!("[,;: ’']")

    sanitize_value = fn value ->
      if Regex.match?(regex, value), do: ~s("#{value}"), else: value
    end

    keys = Map.keys(parameters)
    keys = if sorted, do: Enum.sort(keys), else: keys

    keys
    |> Enum.map(fn key -> "#{String.upcase(key)}=#{sanitize_value.(parameters[key])}" end)
    |> Enum.join(";")
  end
end
