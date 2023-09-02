  package dIngle::Structure
# *************************
; our $VERSION='0.05001'
# **********************
; use strict; use warnings; use utf8

; use Carp ()

; use dIngle::Log _log => 'dIngle.builder.structure'
; use dIngle::Generator

; use parent ('HO::Structure')

; use subs qw/init/

######################################
# dIngle Structure Core
######################################
; use HO::class
    _lvalue => _labels   => '%',
    _lvalue => _property => '%'

; use overload
    '<<'       => "insert"

; sub insert
    { my ($self,@args) = @_
    ; $self->get_root->insert(@args)
    ; return $self
    }

######################################
# dIngle Structure As A Basis Class
######################################
; use dIngle::I18N
; use dIngle::Generic

; import from 'dIngle::Generic'    => qw/label/
; import from 'dIngle::I18N::i18n' => qw/i18n/

# implementiert Einfachvererbung mit Code::Loader save
# Module Laden
; sub import
    { my ($class,$base) = @_
    ; my $thing = caller#; warn "$class => $thing => $base"

    ; if($base)
        { dIngle->load->by_pkg($base)->structure
        ; no strict 'refs';
        ; @{"${thing}::ISA"} = map {
            $_ eq 'dIngle::Structure' ? $base : $_ } @{"${thing}::ISA"}
        }

    ; export from 'dIngle::Generic'
        => node
        => newline
        => vishtml
        =>
        
    # now I can spare one line more without a loss on functionality
    ; strict->import
    ; warnings->import
    ; warnings->unimport('void')
    ; utf8->import
    }

# for all structures with overwritten constructor
; sub init { my ($struct,$obj) = @_; return $struct }

# Overwritten for easier error detection
; sub fill ($$@)
    { my ($obj,$key,@args) = @_
    ; Carp::croak("'$key' not is not a area name.")
        unless defined $obj->_areas->{$key}
    ; $obj->_areas->{$key}->insert(@args)
    ; return $obj
    }

# Abstrakte Methode: Keine Zauberei in der Basisklasse: wenn die Domain
# gebraucht wird, muss diese Methode ueberschrieben werden.
# defines the i18n domain
; sub domain
    { my ($self)=shift
    ; warn "No i18n domain defined in package ".ref($self)." .\n"
    ; 'template_failure'
    }

# Structures haben eine eigene i18n Funktion damit beim Extrahieren der Strings
# zur Erstellung der MO-Dateien jeder String seinem Modul zugeordnet werden
# kann.
# TODO -- i18n with stylish structures and many things more
#
# everything is hackish
; sub st_i18n
    { my ($self,$key,@args) = @_

    ; local $dIngle::I18N::DOMAIN = $self->domain()
    ; my $level = $self->isa('dIngle::Structure::Template') ? 2 : 1

    #; Sub::Uplevel::uplevel($level,\&i18n,$key,@args)
    ; i18n($key)
    }

# convinient shortcut for commonly used operation
; sub get_setter
    { my ($self) = @_
    ; my $A=$self->area_setter()
    ; my $L=$self->label_setter()
    ; ($A,$L)
    }

########################
# Public Methods
########################

# ab Version 0.05 Standardverhalten eines set-Accessors (chainable)
; sub set_label
    { my ($obj,$key,$lbl)=@_
    # The LABEL element is used to specify labels for
    # controls that do not have implicit labels.
    ; $obj->_labels->{$key} = $lbl || label()
    ; return $obj
    }

; sub get_label
    { my ($obj,$key)=@_
    ; return $obj->_labels->{$key}
    }

; sub fill_label
    { my ($obj,$key,@val)=@_
    ; my $lbl=$obj->_labels->{$key}
    ; if( defined $lbl )
        { $lbl->insert( @val ) }
      else
        { _log("debug","Label $key is not defined!")
        }
    ; return $obj
    }

; sub label_setter
    { my $obj=shift
    ; sub
        { my ($slot,$label)=@_
        ; $obj->set_label($slot,$label)
        ; $label = $obj->get_label($slot) unless $label
        ; return $label
        }
    }

#########################
# Properties
#########################
; sub property
    { my ($self,$prop,$val)=@_
    ; if( $val )
        { $self->_property->{$prop} = $val
        ; return $self
        }
      else
        { return $self->_property->{$prop}
        }
    }

########################
# Development Helper
########################
; sub fill_with_area_names
    { my ($self) = @_
    ; for my $area ($self->list_areas)
        {
            $self->fill($area,"<em>$area</em>")
        }
    }

; 1

__END__

=head1 NAME

dIngle::Structure

=head1 SYNOPSIS

=head1 DESCRIPTION

A perl based template system mainly to build templates and texts of any kind.

Special templates for html pages.
