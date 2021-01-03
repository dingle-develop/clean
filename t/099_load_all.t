; use lib 't/lib'

# test the real dIngle sitelib
; use Test::dIngle::Application
; use strict; use warnings

; use Test::More 
; use Path::Tiny qw(path)

; my $directory = path(__FILE__)->parent(2)->child('lib')

; $directory->visit(
    sub {         
        my ($path, $state) = @_;
        return if $path->is_dir;
        my $mod = $path->stringify;
        return unless $mod =~ m/\.pm$/;
        $mod =~ s|^lib/||;
        $mod =~ s|\.pm$||;
        $mod =~ s|/|::|g;
        use_ok($mod);
    }, { recurse => 1 });

; done_testing
