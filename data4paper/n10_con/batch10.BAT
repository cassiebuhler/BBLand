START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\SpatialData.exe" B10.ptc /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Habdyn.exe" B10.pdy /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Metapop.exe" B10.mp /RUN=YES /TEX
move "C:\Users\cb3452\Documents\RAMAS Model Files\*.*" "C:\Users\cb3452\OneDrive - Drexel University\bbland\bbland-github\data\n10"
