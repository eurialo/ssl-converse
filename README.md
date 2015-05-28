ssl-converse
============

This is an example tool for conversation that uses SSL protocol I've made when I worked up with the (ruby) OpenSSL Library. 
As you can see there are the source codes of the server and of the client moreover I have made one 
certificate as sample, I hope that this can be helpful to someone.


Generate your custom certificate
--------------------------------

You can generate your custom certificate by using the following command:

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout example-cert.key -out example-cert.crt

The arguments mean:

* openssl:          This is the basic command line tool for creating and managing OpenSSL certificates, keys, and other files.

* req:              This subcommand specifies that we want to use X.509 certificate signing request (CSR) management. 
                    The 'X.509' is a public key infrastructure standard that SSL and TLS adheres to for its key and certificate 
                    management. We want to create a new X.509 cert, so we are using this subcommand.

* -x509:            This further modifies the previous subcommand by telling the utility that we want to make a self-signed 
                    certificate instead of generating a certificate signing request, as would normally happen.

* -nodes:           This tells OpenSSL to skip the option to secure our certificate with a passphrase. We need Nginx to be able 
                    to read the file, without user intervention, when the server starts up. A passphrase would prevent this from 
                    happening because we would have to enter it after every restart.

* -days 365:        This option sets the length of time that the certificate will be considered valid. We set it for one year here.

* -newkey rsa:2048: This specifies that we want to generate a new certificate and a new key at the same time. We did not create 
                    the key that is required to sign the certificate in a previous step, so we need to create it along with the 
                    certificate. The rsa:2048 portion tells it to make an RSA key that is 2048 bits long.

-keyout:            This line tells OpenSSL where to place the generated private key file that we are creating.

-out:               This tells OpenSSL where to place the certificate that we are creating.


Reference
---------

* Ruby OpenSSL: http://ruby-doc.org/stdlib-2.0/libdoc/openssl/rdoc/OpenSSL.html
