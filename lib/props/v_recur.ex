defmodule ICalendar.Props.VRecur do
  @moduledoc false
  use ICalendar.Props
  alias ICalendar.Props

  @canonical_keys [
    "freq",
    "until",
    "count",
    "interval",
    "bysecond",
    "byminute",
    "byhour",
    "byday",
    "bymonthday",
    "byyearday",
    "byweekno",
    "bymonth",
    "bysetpos",
    "wkst"
  ]

  def get_type(type_name, value) do
    type_name = String.downcase(type_name)

    cond do
      type_name == "freq" ->
        Props.VFrequency.of(value)

      type_name == "until" ->
        Props.VDDDTypes.of(value)

      type_name in ["wkst", "byday"] ->
        Props.VWeekday.of(value)

      type_name in [
        "count",
        "interval",
        "bysecond",
        "byminute",
        "byhour",
        "byweekno",
        "bymonthday",
        "byyearday",
        "bymonth",
        "bysetpos"
      ] ->
        Props.VInt.of(value)
    end
  end

  defp map_keys_to_downcase(m),
    do: Enum.reduce(m, %{}, fn {key, value}, acc -> Map.put(acc, String.downcase(key), value) end)

  @enforce_keys [:value]
  defstruct ICalendar.Props.common_fields()

  def of(%{} = value), do: %__MODULE__{value: map_keys_to_downcase(value)}

  def to_ical(%{value: values} = _data) do
    keys = for key <- Map.keys(values), do: String.downcase(key)
    non_canonical_keys = keys -- @canonical_keys
    sorted_keys = @canonical_keys ++ Enum.sort(non_canonical_keys)

    sorted_keys
    |> Enum.reduce([], fn key, acc ->
      if Map.has_key?(values, key) do
        value = Map.get(values, key)
        value = if is_list(value), do: value, else: [value]
        value = value |> Enum.map(fn v -> ICal.to_ical(get_type(key, v)) end) |> Enum.join(",")
        ["#{String.upcase(key)}=#{value}" | acc]
      else
        acc
      end
    end)
    |> Enum.reverse()
    |> Enum.join(";")
  end

  defimpl ICal do
    def to_ical(data), do: ICalendar.Props.VRecur.to_ical(data)
  end
end
