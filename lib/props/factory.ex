defmodule ICalendar.Props.Factory do
  @moduledoc false
  alias ICalendar.Props

  @property_to_type %{
    ####################################
    # Property value types
    # Calendar Properties
    "calscale" => "text",
    "method" => "text",
    "prodid" => "text",
    "version" => "text",
    # Descriptive Component Properties
    "attach" => "uri",
    "categories" => "text",
    "class" => "text",
    "comment" => "text",
    "description" => "text",
    "geo" => "geo",
    "location" => "text",
    "percent-complete" => "integer",
    "priority" => "integer",
    "resources" => "text",
    "status" => "text",
    "summary" => "text",
    # Date and Time Component Properties
    "completed" => "date-time",
    "dtend" => "date-time",
    "due" => "date-time",
    "dtstart" => "date-time",
    "duration" => "duration",
    "freebusy" => "period",
    "transp" => "text",
    # Time Zone Component Properties
    "tzid" => "text",
    "tzname" => "text",
    "tzoffsetfrom" => "utc-offset",
    "tzoffsetto" => "utc-offset",
    "tzurl" => "uri",
    # Relationship Component Properties
    "attendee" => "cal-address",
    "contact" => "text",
    "organizer" => "cal-address",
    "recurrence-id" => "date-time",
    "related-to" => "text",
    "url" => "uri",
    "uid" => "text",
    # Recurrence Component Properties
    "exdate" => "date-time-list",
    "exrule" => "recur",
    "rdate" => "date-time-list",
    "rrule" => "recur",
    # Alarm Component Properties
    "action" => "text",
    "repeat" => "integer",
    "trigger" => "duration",
    # Change Management Component Properties
    "created" => "date-time",
    "dtstamp" => "date-time",
    "last-modified" => "date-time",
    "sequence" => "integer",
    # Miscellaneous Component Properties
    "request-status" => "text",
    ####################################
    # parameter types (luckily there is no name overlap)
    "altrep" => "uri",
    "cn" => "text",
    "cutype" => "text",
    "delegated-from" => "cal-address",
    "delegated-to" => "cal-address",
    "dir" => "uri",
    "encoding" => "text",
    "fmttype" => "text",
    "fbtype" => "text",
    "language" => "text",
    "member" => "cal-address",
    "partstat" => "text",
    "range" => "text",
    "related" => "text",
    "reltype" => "text",
    "role" => "text",
    "rsvp" => "boolean",
    "sent-by" => "cal-address",
    "value" => "text"
  }

  def get_type_name(property) do
    Map.get(@property_to_type, property, "text")
  end

  def get_type(type_name, value, %Props.Parameters{} = params),
    do: Map.put(get_type(type_name, value), :params, params)

  def get_type(type_name, value) do
    case type_name do
      "text" ->
        Props.VText.of(value)

      "integer" ->
        Props.VInt.of(value)

      "float" ->
        Props.VFloat.of(value)

      "cal-address" ->
        Props.VCalAddress.of(value)

      "boolean" ->
        Props.VBoolean.of(value)

      "binary" ->
        Props.VBinary.of(value)

      "date" ->
        Props.VDDDTypes.of(value)

      "date-time" ->
        Props.VDDDTypes.of(value)

      "geo" ->
        Props.VGeo.of(value)

      "inline" ->
        Props.VInline.of(value)

      "uri" ->
        Props.VUri.of(value)

      "time" ->
        Props.VTime.of(value)

      "recur" ->
        Props.VRecur.of(value)

      "weekday" ->
        Props.VWeekday.of(value)

      "frequency" ->
        Props.VFrequency.of(value)

      "utc-offset" ->
        Props.VUTCOffset.of(value)

      "period" ->
        Props.VPeriod.of(value)

      "date-time-list" ->
        Props.VDDDLists.of(value)

      "duration" ->
        Props.VDuration.of(value)

      _ ->
        Props.VText.of(value)
    end
  end

  def from_ical(property, value) do
    case get_type_name(property) do
      "text" ->
        Props.VText.from(value)

      "integer" ->
        Props.VInt.from(value)

      "float" ->
        Props.VFloat.from(value)

      "cal-address" ->
        Props.VCalAddress.from(value)

      "boolean" ->
        Props.VBoolean.from(value)

      "binary" ->
        Props.VBinary.from(value)

      "date" ->
        Props.VDDDTypes.from(value)

      "date-time" ->
        Props.VDDDTypes.from(value)

      "geo" ->
        Props.VGeo.from(value)

      "inline" ->
        Props.VInline.from(value)

      "uri" ->
        Props.VUri.from(value)

      "time" ->
        Props.VTime.from(value)

      "recur" ->
        Props.VRecur.from(value)

      "weekday" ->
        Props.VWeekday.from(value)

      "frequency" ->
        Props.VFrequency.from(value)

      "utc-offset" ->
        Props.VUTCOffset.from(value)

      "period" ->
        Props.VPeriod.from(value)

      "date-time-list" ->
        Props.VDDDLists.from(value)

      "duration" ->
        Props.VDuration.from(value)

      _ ->
        Props.VText.from(value)
    end
  end
end
