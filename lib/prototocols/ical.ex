defprotocol ICal do
  @moduledoc false

  @doc "TODO"
  def to_ical(data)
end

defimpl ICal, for: ICalendar.Props.VBoolean do
  def to_ical(prop),
    do: ICalendar.Props.VBoolean.to_ical(prop)
end

defimpl ICal, for: ICalendar.Props.VFloat do
  def to_ical(prop),
    do: ICalendar.Props.VFloat.to_ical(prop)
end

defimpl ICal, for: ICalendar.Props.VInt do
  def to_ical(prop),
    do: ICalendar.Props.VInt.to_ical(prop)
end

defimpl ICal, for: ICalendar.Props.VDate do
  def to_ical(prop),
    do: ICalendar.Props.VDate.to_ical(prop)
end

defimpl ICal, for: ICalendar.Props.VDatetime do
  def to_ical(prop),
    do: ICalendar.Props.VDatetime.to_ical(prop)
end

defimpl ICal, for: ICalendar.Props.VCalAddress do
  def to_ical(prop),
    do: ICalendar.Props.VCalAddress.to_ical(prop)
end

defimpl ICal, for: ICalendar.Props.VText do
  def to_ical(prop),
    do: ICalendar.Props.VText.to_ical(prop)
end

defimpl ICal, for: ICalendar.Props.VBinary do
  def to_ical(prop),
    do: ICalendar.Props.VBinary.to_ical(prop)
end

defimpl ICal, for: ICalendar.Props.VDDDTypes do
  def to_ical(prop),
    do: ICalendar.Props.VDDDTypes.to_ical(prop)
end
