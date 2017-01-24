util = require 'util'
child_process = require 'child_process'

module.exports = (robot) ->
    robot.respond /committee/i, (msg) ->
        text = ">>>Committee: \n"
        text += "*Chair*: Jack Romo _ !sharackor _\n"
        text += "*Secretary*: Joni Lev _ !pigeonenthusiast _\n"
        text += "*Treasurer*: Al Prusokas _ !geofly _\n"
        text += "*Press Officer*: Tara Copplestone _ !gamingarchero _\n"
        text += "*Relations*: Paul Dunn _ !loresco _\n"
        text += "*Ordinary*: Rachel Byrom _ !ray _\n"
        text += "*Ordinary*: Liz Mo _ !e.mo _\n"
        text += "*Ordinary*: Michael Walsh _ !michael_w _\n"
        msg.send(text)

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
        