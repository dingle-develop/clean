  package dIngle::System::Build::Tasks
# ************************************
; our $VERSION = '0.02'
# *********************

; use dIngle::Hive::API qw(task)
; use dIngle::Tasks::Perform qw(make take run)

; sub setup
{
    
; task("Build all", sub
    { my ($context) = @_
    ; my $project = $context->project
    ; my @modules = $project->list_modules( buildable => 1 )
    ; 
    ; make("Build module", $context, $_) for @modules
    })

; task("Build module", sub
    { my ($context,$module) = @_

    ; my $mod = $module->fullname
    ; if(my $task = take("Build module $mod",$context))
        { run($task, $context, $module)
        }
      else
        { #make("Hive add module layer",$context,$module)
        ; make("Build module formats",$context,$module) if $module->formats
        ; make("Build module chunks",$context,$module)
        ; #make("Hive drop module layer",$context,$module)
        }
    })
    ->require(sub
        { my ($context,$module) = @_
        ; $module->isa('dIngle::Module')
        })
    
; task("Build module formats", sub
    { my ($context,$module) = @_
    ; my @formats = $module->formats
    
    })
    
; task("Build module chunks", sub
    { my ($context,$module) = @_
    ; ''
    })

} # end setup

; 1

__END__

=head1 NAME

dIngle::System::Build::Tasks

=head1 DESCRIPTION

=over 4

=item "Build all"

This task is commonly the start for build of whole projects.
It builds by default all buildable modules.

=back



 	 ; sub build_module 
109 	0 	  	  	0 	  	     { my ($self,%args) = @_ 
110 	  	  	  	  	  	     ; Carp::croak "No module set for build_module."  
111 	0 	0 	  	  	  	         unless $self->module( $args{'module'} ) 
112 	  	  	  	  	  	   
113 	0 	0 	  	  	  	     ; if(dIngle->isdef("Build Module " . $self->module)) 
114 	0 	  	  	  	  	         { my $obj = $self->module->buildobject 
115 	0 	  	  	  	  	         ; $obj->take("Build Module " . $self->module) 
116 	  	  	  	  	  	         } 
117 	  	  	  	  	  	       else 
118 	0 	  	  	  	  	         { $self->build_sites(%args) 
119 	  	  	  	  	  	         } 
120 	  	  	  	  	  	   
121 	0 	0 	  	  	  	     ; unless($args{'no_chunks'}) 
122 	0 	  	  	  	  	         { my @chunks = $self->get_chunks(%args) 
123 	0 	  	  	  	  	         ; foreach my $chunk ( @chunks ) 
124 	0 	0 	  	  	  	             { next unless $self->prebuild_check($self->module,$chunk) 
125 	0 	  	  	  	  	             ; $self->build_chunk($chunk,%args) 
126 	  	  	  	  	  	             } 
127 	  	  	  	  	  	         } 
128 	0 	  	  	  	  	     ; return $self 
129 	  	  	  	  	  	     } 
