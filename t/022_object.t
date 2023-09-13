; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0 qw(is done_testing isa_ok)

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use dIngle::Object
; use dIngle::Document::HTML

; my $object = new dIngle::Object::

; is($object->string,'')
; isa_ok($object->header,"HO::Node")
; isa_ok($object->document,"HO::Node")

; my $document = new dIngle::Document::HTML::

; $object->insert($document)

; my $expect = <<'EOT'
<!DOCTYPE html>
<html>
<head>
</head>
<body>
</body>
</html>
EOT
; is $object->string,$expect

; done_testing()
