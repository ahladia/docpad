# Import
pathUtil = require('path')

# Export
module.exports = docpadUtil =
	# Get Local DocPad Installation Executable
	getLocalDocPadExecutable: ->
		return pathUtil.join(process.cwd(), 'node_modules', 'docpad', 'bin', 'docpad')

	# Is Local DocPad Installation
	isLocalDocPadExecutable: ->
		return docpadUtil.getLocalDocPadExecutable() in process.argv

	# Does Local DocPad Installation Exist?
	getLocalDocPadExecutableExistance: ->
		return require('safefs').existsSync(docpadUtil.getLocalDocPadExecutable()) is true

	# Spawn Local DocPad Executable
	startLocalDocPadExecutable: (next) ->
		args = process.argv.slice(2)
		command = ['node', docpadUtil.getLocalDocPadExecutable()].concat(args)
		return require('safeps').spawn command, {stdio:'inherit'}, (err) ->
			if err
				if next
					next(err)
				else
					message = 'An error occured within the child DocPad instance: '+err.message+'\n'
					process.stderr.write(message)
			else
				next?()

	# get a filename without the extension
	getBasename: (filename) ->
		if filename[0] is '.'
			basename = filename.replace(/^(\.[^\.]+)\..*$/, '$1')
		else
			basename = filename.replace(/\..*$/, '')
		return basename

	# get the extensions of a filename
	getExtensions: (filename) ->
		extensions = filename.split(/\./g).slice(1)
		return extensions

	# get the extension from a bunch of extensions
	getExtension: (extensions) ->
		unless require('typechecker').isArray(extensions)
			extensions = docpadUtil.getExtensions(extensions)

		if extensions.length isnt 0
			extension = extensions.slice(-1)[0] or null
		else
			extension = null

		return extension

	# get the dir path
	getDirPath: (path) ->
		return pathUtil.dirname(path) or ''

	# get filename
	getFilename: (path) ->
		return pathUtil.basename(path)

	# get out filename
	getOutFilename: (basename, extension) ->
		if basename is '.'+extension  # prevent: .htaccess.htaccess
			return basename
		else
			return basename+(if extension then '.'+extension else '')

	# get url
	getUrl: (relativePath) ->
		return '/'+relativePath.replace(/[\\]/g, '/')

	# get slug
	getSlug: (relativeBase) ->
		return require('bal-util').generateSlugSync(relativeBase)
