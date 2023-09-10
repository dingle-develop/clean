  package dIngle;
# **********************
  our $VERSION='0.5001';
# **********************
; use strict; use warnings; use utf8

; use dIngle::Loader ()
; use dIngle::Registry ()

; our $LOGGING # which Logging method (log4perl, private, testing, FileSimple,...)
; our $ALL_LANGUAGES = 0 # build with all available languages

#############################
# Class State as Class Data
#############################
; { use Class::Data::Localize
  ; my ($mka,$self) = (\&Class::Data::Localize::mk_classdata,__PACKAGE__)
  ; $mka->($self,'backend','dIngle::Registry::Backends')
  ; $mka->($self,'project')
  ; $mka->($self,'hive')
  ; $mka->($self,'register', dIngle::Registry->new)
  }

#############################
# Class methods also used by dIngle::Object
#############################
; use Package::Subroutine 'dIngle::Loader' => ('load')

; sub configuration
    { return $_[0]->project->configuration
    }

; sub config
    { my $value = shift()->project->configuration->entry(@_)
    ; Carp::carp("Undefined configuration: " . join('.',@_))
        unless defined $value
    ; return $value
    }
    
; sub isdef
    { my ($obj,$key)=@_
    ; dIngle->hive->exists($key)
    }
    

############################
# Development
############################
; sub dump
    { shift;
    ; Carp::carp Data::Dumper::Dumper(@_),"\n"
    #; Carp::carp("dump - from ")
    }

sub debug
    { warn "\n@_\n"
    ; Carp::carp("debug - from ")
    }

; 1

__END__

=head1 NAME

dIngle - builds things

=head1 DESCRIPTION

