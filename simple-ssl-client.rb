#!/usr/bin/env ruby
#
# simple-ssl-client.rb - simple case-study conversation 
# tool that uses SSL protocol (SSL client).
# Federico Fazzi <eurialo@deftcode.ninja>
#

['socket', 'openssl', 'thread'].each(&method(:require))

abort("usage: ruby #{__FILE__} [address] [port]") unless ARGV.length.to_i > 1

# TCP/SSL initialization.
tcp_client      = TCPSocket.new(ARGV[0], ARGV[1].to_i)
ssl_server_cert = OpenSSL::X509::Certificate.new(File.read('certs/example-cert.pem'))
ssl_client      = OpenSSL::SSL::SSLSocket.new(tcp_client)

ssl_client.sync_close = true
ssl_client.connect

# Check valid SSL certificate of the destination.
if ssl_client.peer_cert.to_s != ssl_server_cert.to_s
    $stderr.puts 'Error: unexpected certificate'
    exit
end

puts "Connected to #{ARGV[0]}:#{ARGV[1].to_i}"

# Handle the reception from socket.
Thread.new {
    begin
        # Read the data from SSL server.
        while buf = ssl_client.gets
            buf = buf.chomp
            puts buf
        end
    rescue
        $stderr.puts "Error: #{$!}"
    end
}

# Generate a random alphanumeric nickname.
characters  = [('a'..'z'), (0..9)].map { |i| i.to_a }.flatten
nickname    = (0...15).map { 
    characters[rand(characters.length)] 
}.join.upcase

# Send nickname to the SSL server.
ssl_client.puts ":nickname #{nickname}"

# Handle the client input and send
# the data to the SSL server.
while line = $stdin.gets
    line = line.chomp
    ssl_client.puts line
end