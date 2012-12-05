
pkg   = require '../../package'
exec  = require('child_process').exec
clc   = require 'cli-color'
async = require 'async'

# Description
module.exports.description = 'Deploying Steno to current directory'

# CMD Action
module.exports.action = ->

	stenoChar =
		'''\n
		        _/_/_/    _/                                   
		     _/        _/_/_/_/    _/_/    _/_/_/      _/_/    
		      _/_/      _/      _/_/_/_/  _/    _/  _/    _/   
		         _/    _/      _/        _/    _/  _/    _/    
		  _/_/_/        _/_/    _/_/_/  _/    _/    _/_/       
		\n'''

	# Start
	console.log clc.red.bold(stenoChar)
	

	# =============================================
	# 				Start deploying
	# =============================================

	async.series

		# Clone repo
		clone: (done) ->
			console.log "=> Cloning Steno repository"
			exec "git clone #{pkg.repository.url}", done
		
		# All tasks finished successfull, so output done or error if any
		(err, results) -> if err then console.log clc.red("#{err}") else console.log clc.green('All Done!')
