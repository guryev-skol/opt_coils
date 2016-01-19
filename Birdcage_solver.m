function Birdcage_solver(ls_coilname, us_coilname, coilpath, angle)
% function Birdcage_solver() 
% is a rutine for computing local SAR 
% for a birdcage; function exploits principle of reciprocity 
% i.e. local SAR for Birdcage is computed as a sum of local SARs,
% obtained by consecutive exitation of each port
% while other ports are shorted 

global COIL;
global RHBM;
global SOL;
global SAR;

    
% set constant parameters

N_legs = 16;                        % number of legs
legs_angle = 2 * pi / N_legs;       % angle betweeen two consecutive legs (gaps)
rotation_axis = [0.0, 0.0, 0.0];    % rotate coil around fixed axis

% set SAR file parameters
filename = strcat(SAR.Coil_name, '_angle_')
filename = strcat(filename, num2str(angle));
filename = strcat(filename, '.sar');



%% solve 

S = zeros(size(RHBM));     % this variable stores total local SAR           


%computing SAR for lower shorted  Birdcage  
Load_Coils(ls_coilname, coilpath);   % load coils

%solve for ls
for leg = 1:N_legs
    
    MARIE_Solve_sc();
    
    S = S + SOL.Ssol;
    
    rotate_coil(0, 0, legs_angle, rotation_axis);
end;


%computing SAR for upper shorted  Birdcage  
Load_Coils(us_coilname, coilpath);   % load coils

% solve for us
for leg = 1:N_legs
    
    MARIE_Solve_sc();
    
    S = S + SOL.Ssol;
    
    rotate_coil(0, 0, legs_angle, rotation_axis);
end;

[SAR.maxSAR, I] = max(S(:));
[SAR.ind(1), SAR.ind(2), SAR.ind(3)] = ind2sub(size(S), I);

SAR.maxSAR_cut_x = S(SAR.ind(1), :, :);
SAR.maxSAR_cut_y = S(:, SAR.ind(2), :);
SAR.maxSAR_cut_z = S(:, :, SAR.ind(3));

save(filename, 'SAR');

