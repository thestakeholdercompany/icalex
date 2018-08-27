defmodule ICalendar.Components.Factory do
  @moduledoc false
  alias ICalendar.Components.Component

  def get_component(name, properties \\ %{}, components \\ []) do
    case name do
      "alarm" -> %Component{name: "VALARM", properties: properties, components: components}
      "calendar" -> %Component{name: "VCALENDAR", properties: properties, components: components}
      "event" -> %Component{name: "VEVENT", properties: properties, components: components}
      "freebusy" -> %Component{name: "VFREEBUSY", properties: properties, components: components}
      "journal" -> %Component{name: "VJOURNAL", properties: properties, components: components}
      "timezone" -> %Component{name: "VTIMEZONE", properties: properties, components: components}
      "daylight" -> %Component{name: "DAYLIGHT", properties: properties, components: components}
      "standard" -> %Component{name: "STANDARD", properties: properties, components: components}
      "todo" -> %Component{name: "VTODO", properties: properties, components: components}
      _ -> %Component{name: String.upcase(name), properties: properties, components: components}
    end
  end
end
