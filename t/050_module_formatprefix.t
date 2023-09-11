; use lib 't/lib'
; use Test::dIngle::Light
# teste ob jedes Modul einen anderen Prefix hat

; use Perl6::Junction qw/one/
; use Path::Tiny ()

; use Test2::V0 

; use dIngle::Module

; my @modules
; BEGIN 
  { my $md='t/lib/Trxt/Module'
  ; @modules = map { $_->basename }
      grep { $_->basename !~ /^\.svn$/ && $_->is_dir }
      Path::Tiny::path($md)->children
  }

; ok(@modules > 0,"modules found: " . join(", ",@modules))


; done_testing
