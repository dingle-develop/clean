; use lib 't/lib'
; use Test::dIngle::Light

; use Test2::V0
; plan(6)

; use dIngle::I18N::PO::File

; use IO::File
; use IO::String

############################################
; { 
# read and write a simple entry

  ; my $lines = <<__PO__
#: Hello.pm:10
msgid "Hello, World!"
msgstr "Hallo, Welt!"

__PO__

  ; my $fh = IO::String->new($lines)

  ; my $pofile = dIngle::I18N::PO::File->new()

  ; $pofile->parse_lines($fh,1)

  ; my $result = IO::String->new
  ; $pofile->write_entries($result)

  ; is(${$result->string_ref},$lines)
  }

############################################
# load a test file

; my $filmpo = dIngle::I18N::PO::File->new()
; my $source = "t/locale/module_filme.po"

; my $file = IO::File->new($source,"<:encoding(UTF-8)")
      or Carp::croak("Can't open filehandle: $source")
      
; $filmpo->process_fh($file)

; my @entries = $filmpo->get_entries
; is($entries[0]->msgid(0),"automatisch übertragen?")

# das ist eher ein Entry Test
; ok(!$entries[0]->compare($entries[0]))

#############################################
; {
# read and write an entry with newline

  ; my $lines = <<__PO__
#: Hello.pm:54
msgid "Hello, World! This Message is broken into\\n"
"two parts."
msgstr "Hello, World! This Message is broken into\\n"
"two parts."

__PO__

  ; my $fh = IO::String->new($lines)

  ; my $pofile = dIngle::I18N::PO::File->new()

  ; $pofile->parse_lines($fh,1)

  ; my $result = IO::String->new
  ; $pofile->write_entries($result)

  ; is(${$result->string_ref},$lines)
  }
  
#############################################
; {
# sanitize key
  ; my $lines = <<__PO__
#: Hello.pm:54
msgid "Hello, [World!]"
msgstr "Hello, [World!]"
__PO__

  ; my $fh = IO::String->new($lines)

  ; my $pofile = dIngle::I18N::PO::File->new()

  ; $pofile->parse_lines($fh,1)
  
  ; my $entry = ($pofile->entries)[0]
  
  ; my ($key,$value) = $entry->maketext_entry
  ; is($key,"Hello, ~[World!~]")
  ; is($value,"Hello, ~[World!~]")
  }

