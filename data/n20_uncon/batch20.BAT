START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\SpatialData.exe" B20.ptc /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Habdyn.exe" B20.pdy /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Metapop.exe" B20.mp /RUN=YES /TEX
move "C:\Users\cb3452\Documents\RAMAS Model Files\*.*" "C:\Users\cb3452\OneDrive - Drexel University\bbland\bbland-github\data\n20"
