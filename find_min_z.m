function [z_min_ind, z_max_ind] = find_min_z(z_head_min)
% function searches for min index along z-axis
% where "object's head starts"

global RHBM;

z = RHBM.r(:,:,:,3);

z_max_ind = length(z(1,1,:)); 


for k = 1:z_max_ind - 1
    
    if ((z(1,1,k) <= z_head_min) && (z(1,1,k+1) >= z_head_min))
        
        z_min_ind = k;
        return;
        
    end;
    
    
    
end;
