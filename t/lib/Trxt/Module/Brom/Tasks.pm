  package Trxt::Module::Brom::Tasks;
# **********************************
  our $VERSION='0.01';
# ********************
; use basis 'dIngle::Tasks'

; import from:: vishtml() => qw/Frameset Frame/

; sub setup
    {

; task("DOCTYPE Frameset Document",sub
    { my ($context,$frameset) = @_
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

; task("Brom Frameset",sub
    { my $frs = Frameset()->rows('80,*')
    ; $frs << newline(Frame()->src("?panel")->name("panel"))
           << newline(Frame()->src("?screen")->name("screen"))

    ; return make("DOCTYPE Frameset Document",$frs)
    })
    
    }
# end setup

; 1

__END__

