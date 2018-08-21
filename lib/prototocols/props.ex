defprotocol Props do
  @moduledoc false

  @doc "TODO"
  def to_ical(data)

  #  @doc ""
  #  def from_cal(data)
end

defimpl Props, for: ICalendar.Props.VBoolean do
  def to_ical(%ICalendar.Props.VBoolean{value: value} = _data), do: if value, do: "TRUE", else: "FALSE"
end

defimpl Props, for: ICalendar.Props.VFloat do
  def to_ical(%ICalendar.Props.VFloat{value: value} = _data) when is_float(value), do: Float.to_string(value)
end

defimpl Props, for: ICalendar.Props.VInt do
  def to_ical(%ICalendar.Props.VInt{value: value} = _data) when is_integer(value), do: Integer.to_string(value)
end

defimpl Props, for: ICalendar.Props.VDate do
  def to_ical(%ICalendar.Props.VDate{value: value} = _data) do
    %Date{year: year, month: month, day: day} = value
    format = fn n -> n |> Integer.to_string |> String.pad_leading(2, "0") end
    "#{year}#{format.(month)}#{format.(day)}"
  end
end

defimpl Props, for: ICalendar.Props.VDatetime do

  defp format_date(year, month, day, hour, minute, second) do
    format = fn n -> n |> Integer.to_string |> String.pad_leading(2, "0") end
    "#{year}#{format.(month)}#{format.(day)}#{format.(hour)}#{format.(minute)}#{format.(second)}"
  end

  def to_ical(%ICalendar.Props.VDatetime{value: %DateTime{} = value} = _data) do
    %DateTime{year: year, month: month, day: day, hour: hour, minute: minute, second: second, zone_abbr: zone_abbr} = value
    ts = format_date(year, month, day, hour, minute, second)
    if zone_abbr == "UTC" do
      ts <> "Z"
      else
      # TODO:
      # elif tzid:
      #   self.params.update({'TZID': tzid})
      ts
    end

  end

  def to_ical(%ICalendar.Props.VDatetime{value: %NaiveDateTime{} = value} = _data) do
    %NaiveDateTime{year: year, month: month, day: day, hour: hour, minute: minute, second: second} = value
    format_date(year, month, day, hour, minute, second)
  end
end

defimpl Props, for: ICalendar.Props.VCalAddress do
  def to_ical(%ICalendar.Props.VCalAddress{value: value} = _data) when is_bitstring(value), do: value
end

defimpl Props, for: ICalendar.Props.VBinary do
  def to_ical(%ICalendar.Props.VBinary{value: value} = _data) when is_bitstring(value), do: Base.encode64(value)
end

