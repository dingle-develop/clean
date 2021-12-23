  package dIngle::System::Shell::Tasks
# ************************************
; our $VERSION = '0.01'
# *********************

; use basis dIngle::Tasks

; sub setup
{
; task("Shebang", sub
    { my ($context, $commandline) = @_
    ; return "#!$commandline"
    })

; task("Shebang env", sub
    { my ($context, $command) = @_
    ; return make("Shebang","/usr/bin/env $command")
    })

; task("Shebang bash", sub { make("Shebang env","bash") })

} # end setup

; 1

__END__
