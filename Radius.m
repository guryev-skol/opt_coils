% open geo file to extract radius

coilfile = 'Birdcage_new_l0.1_rad0.1.smm';      %let's assume that we read this filename
filename = coilfile;

last = length(coilfile);

name = coilfile(1:last-4);
extension = coilfile(last-3:last);

if strcmp(extension, '.smm')
    extension = '.geo';
    filename = strcat(name, extension);
else msgbox('wrong filename!!!'); 
end;
    
fid = fopen(filename, 'r');

s = '';

while(strcmp(s,''))
    s = fgetl(fid);
end;

s1 = fgetl(fid);
s_r = fgetl(fid);

r = 'Radius';
k = findstr(s_r, r);

val = s_r ((k+length(r)):length(s_r));
disp (val);

c = textscan(val, '%f');
