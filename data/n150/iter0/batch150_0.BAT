START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\SpatialData.exe" binary150_0.ptc /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Habdyn.exe" both150_0.pdy /RUN=YES /TEX
START /WAIT "title" "C:\Program Files\RAMAS Multispecies 6\Metapop.exe" both150_0.mp /RUN=YES /TEX
move "C:\Users\cb3452\Documents\RAMAS Model Files\*.*" "C:\Users\cb3452\OneDrive - Drexel University\bbland\bbland-github\data\n150\iter0\output\metapop"
move *.KCH "C:\Users\cb3452\OneDrive - Drexel University\bbland\bbland-github\data\n150\iter0\output\habdyn"
move *.DCH "C:\Users\cb3452\OneDrive - Drexel University\bbland\bbland-github\data\n150\iter0\output\habdyn"
