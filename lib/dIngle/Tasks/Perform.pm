  package dIngle::Tasks::Perform;
# *******************************
  our $VERSION='0.02';
# ********************
; use Package::Subroutine ()

; sub import
    { my $self = shift
    ; export Package::Subroutine:: _ => @_
    }

; sub make
    { my ($label, $context, @args) = @_
    ; local $Carp::CarpLevel = $Carp::Carplevel + 1
    ; $context->take($label)->run($context,@args)
    }

; sub take
    { my ($label,$context) = @_
    ; $context->take($label)
    }

; sub run
    { my ($task,$context,@args) = @_
    ; $task->run($context,@args)
    }

; 1

__END__

=head1 NAME

dIngle::Tasks::Perform

=head1 DESCRIPTION

This package defines some funktion which are wrappers around
context object methods. In the autors opinion writing function calls
is easier and the code is more readable.

This module has pure aesthetical purpose.

