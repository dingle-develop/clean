  package dIngle::Library;
# ************************
  our $VERSION = '0.05';
  use strict; use warnings; use utf8
# **********************************
; use autodie
; use autouse 'Carp' => qw/carp/
; use Config::General ()
; use File::Spec ()
; use Path::Tiny ()
; use dIngle::Light

; my @configs = ('dingle-lib.conf','site-lib.conf')
; my @repositories = ('github','private')

; my (%mods,%libs)

; my $load_config = sub
    { my ($path,$file) = @_
	; my $sitelib = File::Spec->catfile($path,$file)
	; return () unless -f $sitelib or -l $sitelib
    ; return Config::General->new(-ConfigFile => $sitelib)->getall;
    }

; my $real_lib = sub
    { my ($lib,$base) = @_
    ; unless( Path::Tiny::path($lib)->is_absolute )
        { $lib = File::Spec->catdir($base, $lib)
        }
    ; return $lib
    }

; sub import
	{ my ($pack,$path,$base) = @_ 
	; $path ||= dIngle::Light->configpath
	; $base ||= dIngle::Light->basepath
	; for my $config (@configs)
	   { my %conf = $load_config->($path,$config)
	   ; my $dir = $conf{'directoryname'} 
	       || Path::Tiny::path($config)->basename('.conf')
	   ; my $lib = $real_lib->($dir,$base)
	   ; for my $source (@repositories)
	       { for my $account (keys %{$conf{$source}})
	           { while( my ($repo,$modlist) =
	                each(%{$conf{$source}{$account}{'repo'}}))
	               { for my $module (keys %$modlist)
	                   { $module =~ s/::/\//g
	                   ; $mods{ "$module.pm" } = $repo
	                   ; $libs{ "$module.pm" } = $lib
	   }}}}}
	
	; unshift @INC , sub
	    { my ($sub,$mod) = @_
	    ; if(exists($mods{ $mod }))
	        { my $filename = File::Spec->catfile(
	              $libs{ $mod }, $mods{ $mod }, 'lib', $mod)
	        ; open (my $fh, "<", $filename)
	        ; $INC{$mod} = $filename
	        ; return $fh
	        }
	    ; return
	    }
	}

#; END { print Data::Dumper::Dumper(\%INC) }

; 1

__END__


