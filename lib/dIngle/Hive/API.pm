  package dIngle::Hive::API;
# **************************
  our $VERSION='0.01_001';
# ************************
; use strict; use warnings; use utf8

; use Carp ()
; use Ref::Util ()
; use dIngle::Log ()
; use dIngle::Tasks::Task ()

; sub task
    { my ($id,$perform)=@_
        
    ; my $module = scalar caller
    ; my $task = new dIngle::Tasks::Task::({
        label => $id,
        module => $module,
        on_destroy => sub { dIngle->hive->insert_task(shift) }
      })
    ; if($perform)
        { unless( Ref::Util::is_coderef($perform) )
            { Carp::croak("Second parameter for task needs to be a coderef.")
            }
        ; $task->perform($perform)
        }
    ; return $task
    }

; sub alias
    { my $key=shift
    ; my @arg=@_
    ; sub { my $obj=shift(@_)
         # ; print "KEY $key\n"
         # ; print join ".", @_
         # ; print "\n"
          ; my @args=(@arg,@_)
          ; $obj->take($key,@args)
          }
    }

; 1

__END__

    ; Carp::croak("Not a code ref.") unless ref $sub eq "CODE"

    ; my $caller = "".((caller __PACKAGE__->calllevel)[0])
    ; my $modidx = __PACKAGE__->module_index;

    ; my $mn = (split /::/,$caller)[$modidx] # get module name
    ; unless($mn)
        { dIngle::Log->get_logger('dIngle')
            ->warn("Caller Module: $caller Module index: $modidx")
        }

    ; my $ensure=sub
        { ref($_[0]) eq "dIngle" ? 0 : 1
        }
    ; &CHEST->{$CURRENT}->insert_always
        ( $id, {  perform  => sub{$sub}
               , 'require' => $lock->{'require'} ? sub{$lock->{'require'}} : undef
               ,  ensure   => $lock->{'ensure'}  ? sub{$lock->{'ensure'}}
                                                 : sub{$ensure}
               }
        )

    ; set_label($id,$mn)
    ; dIngle::Log->get_logger('dIngle')
        ->debug("insert [$id] from $mn in $CURRENT")
    
; sub CHEST {{ }}

# another insert function with different calling convention
; sub chadd
    { my $id=shift
    ; local $_
    ; my %lock
    ; if( ref($_[0]) eq 'HASH' )
        { %lock = %{$_[0]} 
        }
      else
        { %lock = @_ 
        }
    ; my $caller = "".((caller __PACKAGE__->calllevel)[0])
    ; my $modidx = __PACKAGE__->module_index
    ; my $mn = (split /::/,$caller)[$modidx]
    ; unless($mn)
        { dIngle::Log->get_logger('dIngle')->warn("Caller Module: $caller Module index: $modidx")
        }

    ; my %multientry

    ; foreach my $part ( keys %lock )
        { my $key = lc $part

        ; if(ref($lock{$part}) eq 'CODE')
             { $multientry{dIngle->backend}{$key} = sub{$lock{$part}}
             }
          elsif(ref($lock{$part}) eq 'HASH')
             { foreach my $backend (keys %{$lock{$part}})
                 { $multientry{$backend}{$key} = sub{$lock{$part}->{$backend}}
                 }
             }
          else
             { croak( "Argument for '$part' should in '$key' is no code "
                     ."or hash reference.")
             }
        }

    ; foreach my $backend (keys %multientry)
        { dIngle->backend($backend,my $local)
        ; &CHEST->{$CURRENT}->insert_always($id,$multientry{$backend})
        ; set_label($id,$mn)

        ; dIngle::Log->get_logger('dIngle')->debug
            ("insert [$id] from $mn in $backend/$CURRENT [".join(",",keys %lock)."]")
        }


    }
