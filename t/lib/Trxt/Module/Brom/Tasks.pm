  package Trxt::Module::Brom::Tasks;
# **********************************
  our $VERSION='0.01';
# ********************
; use basis 'dIngle::Tasks'

; import from:: vishtml() => qw/Frameset Frame/

; sub setup
    {

; vchestf("DOCTYPE Frameset Document",sub
    { my ($obj,$frameset) = @_
    ; return sprintf(<<'__HTML__',$frameset)
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>Frameset mit Sitemap</title>
</head>
%S
</html>
__HTML__
   })

; vchestf("Brom Frameset",sub
    { my $frs = Frameset()->rows('80,*')
    ; $frs << newline(Frame()->src("?panel")->name("panel"))
           << newline(Frame()->src("?screen")->name("screen"))

    ; return make("DOCTYPE Frameset Document",$frs)
    })
    
    }

; 1

__END__

