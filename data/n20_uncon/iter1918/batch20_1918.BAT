START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\SpatialData.exe" X20_1918.ptc /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Habdyn.exe" Z20_1918.pdy /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Metapop.exe" Z20_1918.mp /RUN=YES /TEX
move "C:\Users\cb3452\Documents\RAMAS Model Files\*.*" "C:\Users\cb3452\OneDrive - Drexel University\bbland\bbland-github\data\n20\iter1918\output"
