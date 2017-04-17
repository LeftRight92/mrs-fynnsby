ical = require('ical')
moment = require('moment')

config =
  #calendar: process.env.ICAL_CALENDAR_URL
  calendar: "https://calendar.google.com/calendar/ical/yusu.org_vs6osjkbnb39uro0m7u33qvntk%40group.calendar.google.com/public/basic.ics"

module.exports = (robot) ->
  robot.respond /events/i, (msg) ->
    text = "test \n"
    #retrieve the events
    ical.fromURL config.calendar, {}, (err, data) ->
      today = moment(0, "HH")
      events = (data[key] for key of data).map (e) ->
        e.start = moment(e.start)
        e.end = moment(e.end)
        e
      .filter (e) -> e.start.isSameOrAfter(today, 'day')

      events.shift(); #remove the weird 'undefined' event always at the start

      text += "Event Count: #{events.length}\n"

      events.sort (a, b) ->
        a.start - b.start

      if events.length is 1
        msg.send "There are no events currently on the calendar."
        return

      firstEvent = events.shift();
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
      robot.emit 'slack.attachment',
        message: "Events Information:"
        content:
          fallback: firstEvent.summary
          title: firstEvent.summary
          text: firstEvent.description
          fields: [{
            title: "Location"
            value: firstEvent.location
          },{
            title: "Time"
            value: firstEvent.start.format('dddd, hh:mma')
          }]
      #msg.send text
