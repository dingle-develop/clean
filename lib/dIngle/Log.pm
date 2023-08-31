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
        { my $logtarget = @_ == 1 ? $self : shift
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
    { shift() # until now it is called as a method!

    ; if( defined($dIngle::LOGGING) && lc($dIngle::LOGGING) eq 'log4perl' )
        { unless( $log4perl )
            { require Log::Log4perl
            ; Log::Log4perl->init($log4perlconfig)
            ; $log4perl=sub { Log::Log4perl->get_logger(@_) }
            }
        ; return $log4perl->(@_)
        }
      elsif((defined($dIngle::LOGGING) && lc($dIngle::LOGGING) eq 'testing')
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

The alternative is to get the logger object via class method C<get_logger>.

   dIngle::Log->get_logger('dIngle.builder.something')->info(...)

=head1 DESCRIPTION

=head2 import

If you  use the module, there is the possibilty to create log
functions in the loading package. Use a plain hash with function
name as key and logging target as value. The logging target is used
by Log4perl to organize the log messages.

The exported function needs two parameters. First argument is the
loglevel which is used as log4perl method. Second argument is the
log message.

=head2 Log classes

Until now there are three ways to log or even do not log messages.
To choose which log class is used the global variable C<$dIngle::LOGGING>
can be set during initialization. 

=over 4

=item Log::Log4perl

    $dIngle::LOGGING = 'log4perl';

dIngle::Log supports the great Log::Log4perl module.
Log::Log4perl's configuration is stored at config/log4perl.conf.

The configuration file can be changed during loading.

    use dIngle::Log log4perlconfig => 'config/my-log4perl.conf';

=item Null Logger

This is the default for performance reasons.

=item Testing Logger

    $dIngle::LOGGING = 'Testing';
    
This Logger will also be used if C<$0> file ending is *.t.

=back

=head1 SEE ALSO

L<Log::Log4perl>
