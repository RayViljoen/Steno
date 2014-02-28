
# ======================================================
# 	Handles email parsing
# ======================================================

config = require '../config'

MailParser = require('mailparser').MailParser 	# https://github.com/andris9/mailparser
cheerio = require 'cheerio'						# https://github.com/MatthewMueller/cheerio

# Get database object
db = require './db'

# Factory parser
module.exports = (raw) ->
	
	# New parse instance
	mailparser = new MailParser()

	# Send the raw email to the parser syncronously
	# Doing it syncronously is ok as the factory is run async
	mailparser.write(raw)
	mailparser.end()

	# Listen when the parsing finishes
	mailparser.on 'end', (email) ->

		# Get from email or log and return if none
		return unless sender = email.from[0].address

		# Check message is from a valid user
		unless config.users[sender]
			elog "Invalid user: #{sender}"
			return

		# Get html or text from parsed email
		rawMsg = email.html or email.text
		
		# Load message into cheerio wrapped into 'steno' div
		$ = cheerio.load "<div id='root_steno_container'>#{rawMsg}</div>"

		# Get raw text
		message = do $('#root_steno_container').text

		# Strip Airmail style prefix
		message = message.replace 'body{font-family:Helvetica,Arial;font-size:13px}', ''

		# Split at delimiters
		message = (message.split '--END--')[0]
		message = (message.split '--end--')[0]
		message = (message.split '-- \n')[0]
		message = (message.split '-- ')[0]
		message = do message.trim

		# Save message
		db.set sender, message
		