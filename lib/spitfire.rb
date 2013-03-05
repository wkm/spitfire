require "spitfire/version"
require 'thor'

require 'net/ssh'

def channel_execute(session, command, prefix = '')
  $stdout.sync
  return session.open_channel do |ch|
    $stdout.print "#{prefix} !! #{command}"
		ch.exec command do |ch|
			ch.on_data do |c,data|
				$stdout.print "#{prefix}> #{data}"
			end

			ch.on_extended_data do |ch, type, data|
				$stderr.print "#{prefix}:ERR> #{data}"
			end

			ch.on_eof do |ch|
				$stdout.print "#{prefix} [eof]"
			end

			ch.on_close do |ch|
				$stdout.print "#{prefix} [closed]"
			end
		end
      
		ch.wait
	end
end

module Spitfire
	class CLI < Thor
		desc 'transfer', 'transfer files'
		method_option :source_host, default: '127.0.0.1'
		method_option :source_user
		method_option :source_dir, default: '.'

		method_option :port_number, default: '56789'
		method_option :destination_host, required: true
		method_option :destination_user
		method_option :destination_dir, required: true

		def transfer
			source_user = options['source_user']
			source_user ||= %x[whoami].strip

			destination_user = options['destination_user']
			destination_user ||= source_user

			puts "Connecting to destination: #{options.destination_host} as #{destination_user}"
			destThread = Thread.new {
				destination = Net::SSH.start(options.destination_host, destination_user)
			    destChannel = channel_execute(
			      destination, 
			      "echo 'ok'; mkdir -p #{options.destination_dir}; cd #{options.destination_dir}; nc -vl #{options.port_number} | tar xvvf -", 
			      'DEST'
			    )
				destination.loop{true}
			}


			sleep(2)
			puts "Connecting to source: #{options.source_host} as #{source_user}"
			srcThread = Thread.new {
				source = Net::SSH.start(options.source_host, source_user) 
				command = "echo 'ok'; cd #{options.source_dir}; tar vvc . | nc -v #{options.destination_host} #{options.port_number}"
		    
			    srcChannel = channel_execute(
			      source,
			      command,
			      ' SRC'
			    )
				source.close()
			}


			# wait for the source to finish
			srcThread.join

			# okay, now pause and kill the destination
			sleep(2)
			destThread.kill
		end  
	end
end