ical = require('ical')
moment = require('moment')

config =
  calendar: process.env.ICAL_CALENDAR_URL

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
      events.sort (a, b) ->
        a.start - b.start

      if events.length is 1
        msg.send "There are no events currently on the calendar."
        return

      msg.send {
          attachments: [
              {
                  fallback: "Uh-oh, error!"
                  pretext: "Here's the next event: "
                  color: "#695ce5"
                  title: "Next Event: " + events[0].summary
                  text: if events[0].description then "#{events[0].description}" else ""
                  fields: [
                      {
                          title: "Location"
                          value: if events[0].location then "#{events[0].location}" else ""
                          short: true
                      }
                      {
                          title: "Time"
                          value: events[0].start.format('dddd, hh:mma')
                          short: true
                      }
                  ]
              }
          ]
      }
