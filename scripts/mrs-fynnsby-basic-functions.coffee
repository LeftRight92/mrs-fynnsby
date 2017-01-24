module.exports = (robot) ->
	robot.respond /committee/i, (msg) ->
		text = ">>>Committee: \n"
		text += "**Chair**: Jack Romo _ @sharackor _\n"
		text += "**Secretary**: Joni Lev _ @pigeonenthusiast _\n"
		text += "**Treasurer**: Al Prusokas _ @geofly _\n"
		text += "**Press Officer**: Tara Copplestone _ @gamingarchero _\n"
		text += "**Relations**: Paul Dunn _ @loresco _\n"
		text += "**Ordinary**: Rachel Byrom _ @ray _\n"
		text += "**Ordinary**: Liz Mo _ @e.mo _\n"
		text += "**Ordinary**: Michael Walsh _ @michael_w _\n"
		msg.send(text)

	