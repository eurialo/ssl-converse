#!/usr/bin/env ruby
#
# simple-ssl-server.rb - simple case-study conversation 
# tool that uses SSL protocol (SSL server).
# Federico Fazzi <eurialo@deftcode.ninja>
#

['socket', 'openssl', 'thread', 'pp'].each(&method(:require))

abort("usage: ruby #{__FILE__} [port]") unless ARGV.length.to_i > 0

# TCP/SSL initialization.
tcp_client          = TCPServer.new(ARGV[0].to_i)
ssl_context         = OpenSSL::SSL::SSLContext.new
ssl_context.cert    = OpenSSL::X509::Certificate.new(File.read('certs/example-cert.pem'))
ssl_context.key     = OpenSSL::PKey::RSA.new(File.read('private/example-cert.key'))
ssl_server          = OpenSSL::SSL::SSLServer.new(tcp_client, ssl_context)

# Connections container.
connections         = []

puts "Listening on port #{ARGV[0].to_i}"

loop do
    begin
        # Accept the client connections.
        connection = ssl_server.accept

        # Get at first the nickname.
        buf = connection.gets

        # Set the client nickname.
        if buf.include?(':nickname')
            nickname = buf.split(' ').last
            connections << {
                :connection => connection,
                :nickname   => nickname
            }

            puts "Assigned nickname client to: #{nickname}"
        end

        puts "Accepted connection from #{connection.to_io.addr[2]}"

        # Handle the reception from clients.
        Thread.new {
            begin
                # Read data from the clients.
                while buf = connection.gets
                    buf = buf.chomp

                    # Display the received data from the 
                    # client to the server console.
                    to_server = "#{nickname} said: #{buf}"
                    puts to_server

                    # Broadcast the client data to the other
                    # clients except to the sender.
                    connections.each { |c|
                        if c[:nickname] != nickname
                            to_client =  "#{nickname} said: #{buf}"
                            c[:connection].puts to_client
                        end
                    }
                end
            rescue
                $stderr.puts "Error: #{$!}"
            end
        }
    rescue
        $stderr.puts "Error: #{$!}"
    end
end