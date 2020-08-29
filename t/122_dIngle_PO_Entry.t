; use lib 't/lib'
; use Test::dIngle::Light

; use Test2::V0

; use dIngle::I18N::PO::Entry

; my $null = dIngle::I18N::PO::Entry->new
; like( warning { "$null" }, qr/Empty msgid in PO Entry! .*/, "Empty msgid warns.")

; is( $null->gettext_msgid, '', 'empty msgid')
; is( $null->gettext_msgstr, '', 'empty msgstr')

; my $test = dIngle::I18N::PO::Entry->new
    ( msgid => ["Eins","Zwei"]
    )
; $test->msgstr('<',$_) for ("Lauf","Dahin")
    
; is( $test->gettext_msgid, "Eins\nZwei", "test gettext_msgid" )
; is( $test->gettext_msgstr, "Lauf\nDahin", "test gettext_msgstr" )

; done_testing()
