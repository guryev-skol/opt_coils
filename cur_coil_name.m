function coilname = cur_coil_name(l, rad)
%function cur_coil_name
%function produces the name of the COIL of interest


ext = '.smm';
coilname = 'Birdcage_new_l';

coilname = strcat(coilname, num2str(l*10^3));
coilname = strcat(coilname, '_rad');
coilname = strcat(coilname, num2str(rad*10^3));
coilname = strcat(coilname, ext);