{exec, spawn} = require "child_process"

options =
	src: "src/"
	target: "lib/"

task "build", "Build the files from #{options.src} into #{options.target}", ->
   exec "coffee --compile --output #{options.target} #{options.src}"

task "watch", "Watch coffee-script files in #{options.src} for changes and compile them into #{options.target}", ->
  c = spawn "coffee", "--compile --watch --output #{options.target} #{options.src}".split(' ')
  c.stdout.on 'data', (data)-> process.stdout.write data
  c.stderr.on 'data', (data)-> process.stderr.write data