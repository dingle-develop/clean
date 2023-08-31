  package dIngle::Log
# *******************
; our $VERSION='0.05001'
# **********************
; use strict; use warnings; no warnings 'once'

; use dIngle
; use Package::Subroutine ()
; my $log4perlconfig = 'config/log4perl.conf' 

; sub import
    { my ($pack,%args)=@_
    ; my $caller = caller
    ; foreach my $method (keys %args)
        { if($method eq 'log4perlconfig')
            { $log4perlconfig = $args{log4perlconfig}
            ; next
            }
        ; my $trg = $args{$method}
        ; my $sub = sub
            { my ($lvl,$msg) = @_
            ; my $log=dIngle::Log->get_logger($trg)

            ; if( ref($log) eq 'Log::Log4perl::Logger' )
                { local $Log::Log4perl::caller_depth
                      = $Log::Log4perl::caller_depth + 1
                ; $log->$lvl($msg)
                }
              else
                { $log->$lvl($trg,$msg)
                }
            }
        ; install Package::Subroutine:: $caller => $method => $sub
        }
    }

###########################################
#
# Internes Log zur Zeit nur für
# die Entwicklung.
#
###########################################

; package dIngle::Log::Private
# ******************************
; our $VERSION=$dIngle::Log::VERSION
# ************************************

; sub AUTOLOAD
    { our $AUTOLOAD
    ; if( $dIngle::Log::DEBUG )
        { require Carp
        ; Carp::carp $AUTOLOAD
        }
    }

; sub DESTROY { 'AHOI' }

###########################################
#
# In Testskripten sollten Warnungen 
# mit ausgegeben werden
#
###########################################

; package dIngle::Log::Testing

; our $VERSION=$dIngle::Log::VERSION
; our $LEVEL =
    { debug => 0
    , info => 0
    , warn => 1
    , error => 1
    , fatal => 1
    }
    
; sub write
    { my ($self,@args) = @_
    ; print STDERR "# " , @args
    }

; sub AUTOLOAD
    { our $AUTOLOAD
    ; our $LEVEL
    ; $AUTOLOAD =~ s/.*:://
    ; my $self = shift
    ; my $method = lc($AUTOLOAD)
    ; my $level = $method eq "log" ? shift() : $method


    ; my $showwarn = $LEVEL->{$level}
    ; if(defined $showwarn)
        { my $logtarget = shift
        ; $self->write("$logtarget: " . $level . " : " . join("\n",@_) . "\n") 
            if $showwarn
        }
      else
        { $self->write( ref $self ? ref $self : $self, "\n")
        ; $self->write( "UNKNOWN LOGLEVEL: $level\n" )
        ; $self->write( "MESSAGE: ", join("\n",@_), "\n")
        }
    }

; sub DESTROY { 'IOHA' }

###########################################

; package dIngle::Log

# Coderef which triggers Log::Log4Perl calls.
; my $log4perl

# Public methods
; sub get_logger
    { shift() # until now it is called as method!

    ; if( defined($dIngle::LOGGING) && $dIngle::LOGGING eq 'Log::Log4Perl' )
        { unless( $log4perl )
            { require Log::Log4perl
            ; Log::Log4perl->init($log4perlconfig)
            ; $log4perl=sub { Log::Log4perl->get_logger(@_) }
            }
        ; return $log4perl->(@_)
        }
      elsif((defined($dIngle::LOGGING) && $dIngle::LOGGING eq 'Log::Testing')
            || $0 =~ /\.t$/)
        { return 'dIngle::Log::Testing'
        }
      else
        { return 'dIngle::Log::Private'
        }
    }

; 1

__END__

=head1 NAME

dIngle::Log

The logging facility of the dIngle Build System.

=head1 SYNOPSIS

Simply import one or more log methods in your module namespace:

   use dIngle::Log
       logprogress => 'dIngle.builder.something',
       logerror    => 'dIngle.fatal.moments';

   logprogress('info','start some groundwork in babel...');

Alternative this class is a base class of dIngle::Application.
So you can use the get logger method.

   $obj->get_logger('dIngle.builder.something')->info(...)

=head1 DESCRIPTION

=head2 import

If you  use this module, there is the possibilty to load log
functions into your namespace. Use a plain hash with function
name as key and logging target method as value as parameter.

The exported function needs two parameters. First argument is the
loglevel which is used as log4perl method. Second argument is the
log message.

=head2 Log classes

Until now there are only two ways to log or even do not log messages.
dIngle::Log supports the great Log::Log4perl module and an null logger
which does nothing with the messages. This is the default for performance
reasons. Log::Log4perl's configuration is stored at config/log4perl.conf.

To choose which log class is used the global variable $dIngle::LOGGING
can be manipulated. If the value is set to 'Log::Log4Perl' than this class
will be used. Changing this value during execution time is not well tested.
So you will doit at your own risk.

=head1 SEE ALSO

L<Log::Log4perl>
