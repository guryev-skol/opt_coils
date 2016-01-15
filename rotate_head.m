function rotate_head(alpha_x, alpha_y, alpha_z)
% function rotates nonzero points in RHBM 
% around a nape + pillow  about z-axis 

global RHBM;

pillow_shift = 0.05;

%% set an origin shift

shift = compute_rotation_shift(pillow_shift);
disp(shift);

%shift = [0;0;0];

%% set a rotation matrix

R_x = [1 0 0;
       0 cos(alpha_x) sin(alpha_x);
       0 -sin(alpha_x) cos(alpha_x)];
   
R_y = [cos(alpha_y) 0 -sin(alpha_y); 
       0 1 0;
       sin(alpha_y) 0 cos(alpha_y)];
   
R_z = [cos(alpha_z) sin(alpha_z) 0;
       -sin(alpha_z) cos(alpha_z) 0;
       0 0 1];
   
%% rotate body around a new origin

[l, w, d] = size(RHBM.r(:,:,:,1));

resh_sz = l * w * d;

x = reshape(RHBM.r(:,:,:,1), [1, resh_sz]);
y = reshape(RHBM.r(:,:,:,2), [1, resh_sz]);
z = reshape(RHBM.r(:,:,:,3), [1, resh_sz]);

shifted_coords = [x - shift(1); y - shift(2); z - shift(3)];

res = R_z * R_y * R_x * shifted_coords;

x = res(1,:) + shift(1);
y = res(2,:) + shift(2);
z = res(3,:) + shift(3);

x = reshape(x, [l, w, d]);
y = reshape(y, [l, w, d]);
z = reshape(z, [l, w, d]);

RHBM.r(:,:,:,1) = x;
RHBM.r(:,:,:,2) = y;
RHBM.r(:,:,:,3) = z;

