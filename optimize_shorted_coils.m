%optimize_coils
%
% script for running marie with specific COIL
% and  RHBM settings 

clear all;
clc;


global COIL;
global RHBM;
global SOL;
global SAR;


%% setting paths

if ispc
    coil_path = 'C:\Users\Georgy\Desktop\opt_coils\data\coils\';
    body_path = 'C:\Users\Georgy\Desktop\opt_coils\data\bodies\';
else 
    coil_path = '~/Desktop/opt_coils/data/coils/';
    body_path = '~/Desktop/opt_coils/data/bodies/';
end;

%body_name = 'RHBM_HT_5mm.vmm';
body_name = 'DUKE_HEAD_3mm.vmm';

%% setting loop parameters

max_theta = pi/12;
min_theta = -pi/12;
N_theta = 15; 

d_theta = (max_theta - min_theta) / N_theta;

% setting l 
l_min = 0.2;
l_max = 0.3;
N_l = 10;

% setting rad 
rad_min = 0.2;
rad_max = 0.35;
N_rad = 15;

d_l = (l_max - l_min) / N_l;
d_rad = (rad_max - rad_min) / N_rad;

%%

Ns_r = 1;
Ns_l = 1;

rad_total = rad_min:d_rad:rad_max-d_rad;
l_total = l_min:d_l:l_max-d_l;

r = datasample(rad_total, Ns_r);
l = datasample(l_total, Ns_l);

%% chose coil model


progress = 0;

h = waitbar(0, 'Start optimization');

for i = 1:Ns_r
    
    rad = r(i);
    
    for j =1:Ns_l 
        
        len = l(j);
        
        init_marie();    % initialize marie               
        SAR_struct;      % initialize SAR structure
        
        % init all structures
        coil_name = cur_coil_name(len, rad);
        [ls_coil_name, us_coil_name] = cur_shorted_coil_names(len, rad);
        
        
        Load_RHBM(body_name, body_path);

        % rotations go here
        
        for k = 1:N_theta
        % simulation
                        
            theta = min_theta + k * d_theta;
            
            Birdcage_solver(coil_name, ls_coil_name, us_coil_name, coil_path, theta);
            
            
            cntr = (i-1) * N_theta * Ns_l + (j-1)* N_theta + k;
            progress = cntr / (N_theta * Ns_l * Ns_r);
            
            waitbar(progress, h,'Progress:')
            
            clear COIL;
            clear SOL;
            clear SAR;
        end;
    end;
end;


