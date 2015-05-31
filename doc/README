This is *mbank-cli*, a basic command-line interface to the online banking
system of mBank.

**Warning**: You use *mbank-cli* on your own risk! The software is provided
“as is”, without warranty of any kind.

**Warning**: *mbank-cli* uses the web interface at https://online.mbank.pl/
(or https://online.mbank.cz/, or https://online.mbank.sk/)
which is subject to change unexpectedly.


Requirements
------------

- Perl (≥ 5.10) with the following Perl modules:

   - Date::Format

   - Date::Parse

   - HTML::Form

   - HTML::HeadParser

   - HTML::TreeBuilder

   - IO::Socket::SSL (≥ 1.31)

   - IPC::Run (optionally, for password encryption)

   - JSON or JSON::PP (the latter is a core module since Perl 5.14)

   - LWP::UserAgent (≥ 5.802)

   - LWP::Protocol::https

   - Net::HTTPS

   - Net::SSLeay

   - Term::ReadLine::Gnu (only required by the “configure” command)

- GnuPG (optionally, for password encryption)

Cheat sheet for free software distributions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Arch Linux::

   pacman -S perl-timedate perl-html-form perl-html-tree perl-lwp-protocol-https
   pacman -S perl-ipc-run gnupg  # for password encryption
   pacman -S perl-term-readline-gnu  # for the “configure” command

Debian 6.0 (squeeze)::

   apt-get install libwww-perl libio-socket-ssl-perl libjson-perl
   apt-get install libipc-run-perl gnupg  # for password encryption
   apt-get install libterm-readline-gnu-perl  # for the “configure” command

Debian 7.0 (wheezy) and later::

   apt-get install libwww-perl libhtml-form-perl
   apt-get install libipc-run-perl gnupg  # for password encryption
   apt-get install libterm-readline-gnu-perl  # for the “configure” command

Cheat sheet for cpanm(1)
~~~~~~~~~~~~~~~~~~~~~~~~
::

   cpanm Date::Format Date::Parse HTML::Form HTML::HeadParser HTML::TreeBuilder IO::Socket::SSL JSON::PP LWP::UserAgent LWP::Protocol::https Net::HTTPS Net::SSLeay
   cpanm IPC::Run  # for password encryption
   cpanm Term::ReadLine::Gnu  # for the “configure” command

CA certificate
--------------

*mbank-cli* has to verify that the server certificate has been signed by a
trusted CA (certificate authority). Unlike many other TLS clients, it
doesn't trust all the CAs whose certificates are installed system-wide, but
only **VeriSign Class 3 Public Primary Certification Authority - G5**, which
is known to be the root CA for mBank.

*mbank-cli* tries to find the certificate in the system certificate directory;
if that fails, it uses ``ca.crt`` from the same directory as the script
itself.

This procedure might not be adequate when the program is installed
system-wide on some operating systems. Packagers/administrators might want
to patch the ``get_default_ca_path()`` subroutine in such case.


.. vim:ft=rst tw=76 ts=3 sts=3 sw=3 et
