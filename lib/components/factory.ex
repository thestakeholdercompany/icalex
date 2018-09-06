defmodule ICalendar.Components.Factory do
  @moduledoc false
  alias ICalendar.Components.Component

  def get_component(name, properties \\ %{}, components \\ []) do
    case name do
      "alarm" ->
        %Component{
          name: "VALARM",
          properties: properties,
          components: components,
          required: ["action", "trigger"],
          singletons: [
            "attach",
            "action",
            "description",
            "summary",
            "trigger",
            "duration",
            "repeat"
          ],
          inclusive: [{"duration", "repeat"}, {"summary", "attendee"}],
          multiple: ["attendee", "attach"]
        }

      "calendar" ->
        %Component{
          name: "VCALENDAR",
          properties: properties,
          components: components,
          required: ["prodid", "version"],
          singletons: ["prodid", "version", "calscale", "method"],
          canonical_order: ["version", "prodid", "calscale", "method"]
        }

      "event" ->
        %Component{
          name: "VEVENT",
          properties: properties,
          components: components,
          required: ["uid", "dtstamp"],
          singletons: [
            "class",
            "created",
            "description",
            "dtstart",
            "geo",
            "last-modified",
            "location",
            "organizer",
            "priority",
            "dtstamp",
            "sequence",
            "status",
            "summary",
            "transp",
            "url",
            "recurrence-id",
            "dtend",
            "duration",
            "uid"
          ],
          exclusive: ["dtend", "duration"],
          multiple: [
            "attach",
            "attendee",
            "categories",
            "comment",
            "contact",
            "exdate",
            "rstatus",
            "related",
            "resources",
            "rdate",
            "rrule"
          ],
          canonical_order: [
            "summary",
            "dtstart",
            "dtend",
            "duration",
            "dtstamp",
            "uid",
            "recurrence-id",
            "sequence",
            "rrule",
            "rdate",
            "exdate"
          ]
        }

      "freebusy" ->
        %Component{
          name: "VFREEBUSY",
          properties: properties,
          components: components,
          required: ["uid", "dtstamp"],
          singletons: [
            "contact",
            "dtstart",
            "dtend",
            "dtstamp",
            "organizer",
            "uid",
            "url"
          ],
          multiple: ["attendee", "comment", "freebusy", "rstatus"]
        }

      "journal" ->
        %Component{
          name: "VJOURNAL",
          properties: properties,
          components: components,
          required: ["uid", "dtstamp"],
          singletons: [
            "class",
            "created",
            "dtstart",
            "dtstamp",
            "last-modified",
            "organizer",
            "recurrence-id",
            "sequence",
            "status",
            "summary",
            "uid",
            "url"
          ],
          multiple: [
            "attach",
            "attendee",
            "categories",
            "comment",
            "contact",
            "exdate",
            "related",
            "rdate",
            "rrule",
            "rstatus",
            "description"
          ]
        }

      "timezone" ->
        %Component{
          name: "VTIMEZONE",
          properties: properties,
          components: components,
          required: ["tzid"],
          singletons: ["tzid", "last-modified", "tzurl"],
          canonical_order: ["tzid"]
        }

      "daylight" ->
        %Component{
          name: "DAYLIGHT",
          properties: properties,
          components: components,
          required: ["dtstart", "tzoffsetto", "tzoffsetfrom"],
          singletons: ["dtstart", "tzoffsetto", "tzoffsetfrom"],
          multiple: ["comment", "rdate", "tzname", "rrule", "exdate"]
        }

      "standard" ->
        %Component{
          name: "STANDARD",
          properties: properties,
          components: components,
          required: ["dtstart", "tzoffsetto", "tzoffsetfrom"],
          singletons: ["dtstart", "tzoffsetto", "tzoffsetfrom"],
          multiple: ["comment", "rdate", "tzname", "rrule", "exdate"]
        }

      "todo" ->
        %Component{
          name: "VTODO",
          properties: properties,
          components: components,
          required: ["uid", "dtstamp"],
          singletons: [
            "class",
            "completed",
            "created",
            "description",
            "dtstamp",
            "dtstart",
            "geo",
            "last-modified",
            "location",
            "organizer",
            "percent-complete",
            "priority",
            "recurrence-id",
            "sequence",
            "status",
            "summary",
            "uid",
            "url",
            "due",
            "duration"
          ],
          exclusive: ["due", "duration"],
          multiple: [
            "attach",
            "attendee",
            "categories",
            "comment",
            "contact",
            "exdate",
            "rstatus",
            "related",
            "resources",
            "rdate",
            "rrule"
          ]
        }

      _ ->
        %Component{name: String.upcase(name), properties: properties, components: components}
    end
  end
end
