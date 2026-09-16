set fac_file [open facnames.txt w]
for {set i 0} {$i < [gtkwave::getNumFacs]} {incr i} {
    puts $fac_file [gtkwave::getFacName $i]
}
close $fac_file
gtkwave::/Time/Zoom/Zoom_Full
gtkwave::setMarker 306000
