function [ls_coil_name, us_coil_name] = cur_shorted_coil_names(l, rad)
% function cur_shorted_coil_name (l, rad)
% function returns names of lower and upper coils based on their
% geometric sizes
%---------------------------------------
% Outputs:
%---------------------------------------
% ls_coil_name - lower shorted coil name
% us_coil_name - upper shorted coil name


ext = '.smm';
ls_coil_name = 'Birdcage_new_shorted_up_l';
us_coil_name = 'Birdcage_new_shorted_low_l';


ls_coil_name = strcat(ls_coil_name, num2str(l*10^3));
us_coil_name = strcat(us_coil_name, num2str(l*10^3));

ls_coil_name = strcat(ls_coil_name, '_rad');
us_coil_name = strcat(us_coil_name, '_rad');

ls_coil_name = strcat(ls_coil_name, num2str(rad*10^3));
us_coil_name = strcat(us_coil_name, num2str(rad*10^3));

ls_coil_name = strcat(ls_coil_name, ext);
us_coil_name = strcat(us_coil_name, ext);

