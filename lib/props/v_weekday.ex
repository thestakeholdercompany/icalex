defmodule ICalex.Props.VWeekday do
  @moduledoc false
  use ICalex.Props

  @enforce_keys [:value]
  defstruct ICalex.Props.common_fields()

  def of(%{"relative" => _, "signal" => _signal, "weekday" => weekday} = value) do
    weekday = String.downcase(weekday)

    cond do
      #      signal != "" and signal not in ["+", "-"] -> # Regex never catch if something else than + or -
      #        raise ArgumentError, message: "Expected signal, got: #{signal}"

      weekday not in ["su", "mo", "tu", "we", "th", "fr", "sa"] ->
        raise ArgumentError, message: "Expected weekday, got: #{weekday}"

      true ->
        %__MODULE__{value: value}
    end
  end

  def of(value) when is_bitstring(value) do
    value = Regex.named_captures(~r/(?<signal>[+-]?)(?<relative>\d?)(?<weekday>\w{2}?)/, value)
    __MODULE__.of(value)
  end

  def from(value) when is_bitstring(value) do
    __MODULE__.of(value)
  end

  defimpl ICal do
    def to_ical(
          %{value: %{"relative" => relative, "signal" => signal, "weekday" => weekday} = _value} =
            _data
        ),
        do: "#{signal}#{relative}#{String.upcase(weekday)}"
  end
end
