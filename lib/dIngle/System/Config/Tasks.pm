  package dIngle::System::Config::Tasks
# *************************************
; our $VERSION='0.01'
# *******************

; use basis 'dIngle::Tasks'

; import from 'dIngle::Tasks::Config' => qw/default/

; sub setup
{
    
; task("Config defaults",sub
    { my ($context) = @_
    ; my $c = $context->project->configuration->entry
    ; make("Config organisation",$c);
    ; make("Config project",$c);
    })
    
; task("Config organisation",sub
    { my ($obj,$c) = @_
    ; default($c,"organisation","homepage","https://github.com/dingle-develop")
    })
    
; task("Config project",alias("NO OP"));

} # end setup

; 1

__END__

=head1 NAME

dIngle::System::Config::Tasks

=head1 DESCRIPTION

This module has the purpose to add configuration values by tasks.

=head2 Tasks

=over 4

=item "Config defaults"

=item "Config organisation" - configuration for your organisation

=item "Config project" - configuration for your project

=back


