  package dIngle::Library;
# ************************
  our $VERSION = '0.05';
  use strict; use warnings; use utf8
# **********************************
; use autodie
; use Config::General ()
; use Path::Tiny ()
; use dIngle::Light ()

; my @repositories = ('github','private')

; my (%mods,%libs)

# add loader to @INC
; BEGIN:
   { unshift @INC , sub
	    { my ($sub,$mod) = @_
	    ; if(exists($mods{ $mod }))
	        { my $filename = Path::Tiny::path($libs{ $mod })
				    ->child( $mods{ $mod } )
				    ->child( 'lib' )->child( $mod )
	        ; open (my $fh, "<", $filename)
	        ; $INC{$mod} = $filename
	        ; return $fh
	        }
	    ; return
	    }
	}
	
	

; my $load_config = sub
    { my ($path,$file) = @_
	; my $sitelib = Path::Tiny::path($path)->child($file)
	; return () unless -f $sitelib or -l $sitelib
    ; return Config::General->new(-ConfigFile => $sitelib)->getall;
    }

; my $real_lib = sub
    { my ($lib,$base) = @_
    ; unless( Path::Tiny::path($lib)->is_absolute )
        { $lib = Path::Tiny::path($base)->child($lib)
        }
    ; return $lib
    }
    
; sub use_library
    { my ($pack,$config) = @_ 
	; my $path = dIngle::Light->configpath
	; my $base = dIngle::Light->basepath
	; my %conf = $load_config->($path,$config)
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
	   }}}}	
	}
	
; sub import
    { my ($pack, @configs ) = @_
	; local $_
	; $pack->use_library( $_ ) for @configs
    }

#; END { print Data::Dumper::Dumper(\%INC) }

; 1

__END__

=HEAD1 NAME

dIngle::Library - lädt die Entwicklungs- und Projektmodule 




