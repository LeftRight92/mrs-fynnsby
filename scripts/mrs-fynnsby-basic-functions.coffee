#util = require 'util'
child_process = require 'child_process'

module.exports = (robot) ->
  robot.respond /committee/i, (msg) ->
    text = ">>>Committee: \n"
    text += "*Chair*: Fynn Levy _ fynnlevy _\n"
    text += "*Vice Chair*: Joni Lev _ pigeonenthusiast _\n"
    text += "*Secretary*: Callum Deery _ cd _\n"
    text += "*Treasurer*: Al Prusokas _ geofly _\n"
    text += "*Publicity Officer*: Tara Copplestone _ gamingarchero _\n"
    text += "*Ordinary*: Michael Bohea _ leftright92 _\n"
    text += "*Ordinary*: Nathan Addison _ skruffye _\n"
    text += "*Ordinary*: Kenric Yuen _ kyric _\n"
    msg.reply(text)

  emailTime = null
  sendEmail = (recipients, subject, msg, from) ->
    mailArgs = ['-s', subject, '-a', "From: #{from}", '--']
    mailArgs = mailArgs.concat recipients
    p = child_process.execFile 'mail', mailArgs, {}, (error, stdout, stderr) ->
      console.log 'stdout: ' + stdout
      console.log 'stderr: ' + stderr
    p.stdin.write "#{msg}\n"
    p.stdin.end()
  standardPreamble = "The following feedback was sent via Slack:\n\n"

  robot.respond /feedback (.*)/i, (msg) ->
    sendEmail process.env.HUBOT_FEEDBACK_EMAIL, "Feedback from Slack", standardPreamble +  msg.match[1], msg.message.user.id
    msg.send "Your feedback has been sent"

  robot.respond /room/i, (msg) ->
    msg.send msg.room
