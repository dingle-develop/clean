  package dIngle::Waypoint
# ************************
; our $VERSION = '0.02'
# *********************
; use strict; use warnings; use utf8

; use dIngle

; use Waypoint __PACKAGE__, 
  Init => {
     project => sub
        { my ($self,$project,$config,$modopt) = (@_,{},{})
        ; $project->basedir(Cwd::getcwd())
        ; $project->load_config(%$config)
        ; $project->load_modules(%$modopt)
        ; dIngle->project($project)
        },
    hive => sub
        { my ($self,$hive) = @_
        ; dIngle->hive($hive)
        },
    i18n => sub
        { my ($self) = @_
        ; local $_

        ; my $lang = dIngle->config('i18n','use')
        ; unless($lang)
            { _logger("error","Oh, bitte eine Sprache in der Konfiguration angeben.")
            ; $lang = 'en'
            }
        ; dIngle::I18N->current_language($lang)

        ; my $tags = dIngle->config("i18n","language")
        ; dIngle::I18N->_all_languages([map { lc } (ref $tags ? @$tags : ($tags))])

        ; if($dIngle::ALL_LANGUAGES)
            { dIngle::I18N->setup_handle($_)
                foreach dIngle::I18N->all_languages
            }
          else
            { dIngle::I18N->setup_handle($lang) 
            }

        ; dIngle::I18N::_logger("debug","Current Language: $lang")
        }
  }

; 1

__END__

=head1 NAME

dIngle::Waypoint

=head1 SYNOPSIS

   dIngle::Waypoint::Init->project($project);

=head1 DESCRIPTION

This Waypoint helps to encapsulate the interaction with the global
values in dIngle, eg. project, hive, backend.

=head2 Init



