START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\SpatialData.exe" X10_506.ptc /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Habdyn.exe" Z10_506.pdy /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Metapop.exe" Z10_506.mp /RUN=YES /TEX
move "C:\Users\cb3452\Documents\RAMAS Model Files\*.*" "C:\Users\cb3452\OneDrive - Drexel University\bbland\bbland-github\data\n10\iter506\output"
