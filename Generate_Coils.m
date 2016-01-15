% Generate COILS for optimization

% In this version we generate BirdCage only!!!

%% fixed COIL parameters 

if ispc
    coilpath = '~\Desktop\MARIE\data\coils';
else
    coilpath = '/Users/georgyguryev/Desktop/MARIE-master/data/coils/';
end;

coil_type = 'Birdcage_new';

Nleg = 16;
Xpos = 0;
Ypos = 0;
Zpos = 0;
Gap = 10^-3;
Wid = 5*10^-3;
Iniangle = 0;

ShieldRad = [];
ShieldLen = [];

  

%% this block generates COILS of given radius

rad_min = 0.20;
rad_max = 0.35;

l_min = 0.2;
l_max = 0.30;

N_r = 15;
N_l = 10;

d_r = (rad_max-rad_min)/N_r;
d_l = (l_max - l_min)/N_l;

%%

str_l = '_l';
str_r = '_rad';

for i = 1:N_l
    
    Len = l_min + d_l*(i-1);
    
    for j=1:N_r
        
        Rad = rad_min + d_r*(j-1);
        
        %current filename 
        
        coilname = strcat(coil_type,str_l,num2str(Len*10^3),str_r, num2str(Rad*10^3));
        filename = strcat(coilpath, coilname);     

        Birdcage_SCOIL_Gen(filename,Nleg,Rad,Xpos,Ypos,Zpos,Len,Wid,Gap,Iniangle,ShieldRad,ShieldLen);
        
        command_1 = sprintf('./src_generate/src_scoil/gmsh.app/Contents/MacOS/gmsh -refine %s', strcat(filename, '.msh'));
        system(command_1);  
        
        % generate the file information in the scm file
        scoilfile = sprintf('%s.smm',filename);
        fid = fopen(scoilfile,'w');
        fprintf(fid,'Birdcage coil, R = %f m, Length = %f m \n', Rad, Len);
        Rho = 1.2579e-08; thickness = 0.0005;
        fprintf(fid,'%f %f\n', Rho, thickness);
        fprintf(fid,'%s.msh', coilname);
        fclose(fid);    
    end;
end;


