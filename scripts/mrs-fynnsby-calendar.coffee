ical = require('ical')
moment = require('moment')

config =
  #calendar: process.env.ICAL_CALENDAR_URL
  calendar: "https://calendar.google.com/calendar/ical/yusu.org_vs6osjkbnb39uro0m7u33qvntk%40group.calendar.google.com/public/basic.ics"

module.exports = (robot) ->
  robot.respond /events/i, (msg) ->
    #msg.send robot.sdfsdfsd
    text = "test \n"
    #retrieve the events
    ical.fromURL config.calendar, {}, (err, data) ->
      today = moment(0, "HH")
      events = (data[key] for key of data).map (e) ->
        e.start = moment(e.start)
        #e.end = moment(e.end)
        e
      .filter (e) -> e.start.isSameOrAfter(today, 'day')

      events.shift() #remove the weird 'undefined' event always at the start

      text += "Event Count: #{events.length}\n"

      events.sort (a, b) ->
        a.start - b.start

      if events.length is 1
        msg.send "There are no events currently on the calendar."
        return

      firstEvent = () ->
        events.shift()
        events.shift()

      firstEvent.start = moment(firstEvent.start)
      text += firstEvent.summary + "\n"

      text += events.map (e) ->
        location = if e.location then " @#{e.location}" else ''
        start =
          if false
            "This" + e.start.format('dddd, hh:mma')
          else
            e.start.format('Do MMM hh:mma')
        "#{e.summary}#{location} (#{start})"
      .join "\n"

      msg.send {
          attachments: [
              {
                  fallback:
                  pretext: "Here's the next event: "
                  title: "Next Event: " + events[0].summary
                  text: if events[0].description then "#{events[0]/.description}" else ""
                  fields: [
                      {
                          title: "Location"
                          value: if events[0].location then "#{events[0].location}" else ""
                      },
                      {
                          title: "Time"
                          value: events[0].start.format('dddd, hh:mma')
                      }
                  ]
              }
          ]
      }
