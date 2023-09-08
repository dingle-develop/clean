; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0 qw(is done_testing)

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use dIngle::Document::HTML ()

; my $doc = new dIngle::Document::HTML::

; my $expect = <<EOT
<!DOCTYPE html>
<html>
<head>
</head>
<body>
</body>
</html>
EOT

; is("$doc",$expect)

; done_testing()
