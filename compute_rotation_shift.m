function  shift = compute_rotation_shift( pillow_shift, opt1)
% function computes rotation shift due to change of origin

global RHBM;
global SAR;

%max = 1;
%min = 0;
z_head_min = -0.10; % lower bound along z-axis  

[z_min, ~] = find_min_z(z_head_min);    % index range for imaging head

[i_x, i_y, i_z] = ind2sub(size(RHBM.epsilon_r), RHBM.idxS);

if nargin > 1
    type = opt1;
else
    type = 1;
end;
switch type
    
%case max for head model, 
%where nose points in negative direction
    case 1
        
        x_max = 0.0;
        y_max = 0.0;
        %z_max = 0;

        for ind = 1:length(i_z)

            if(i_z(ind) >= z_min)

                x_body = RHBM.r (i_x(ind), i_y(ind), i_z(ind), 1);
                y_body = RHBM.r (i_x(ind), i_y(ind), i_z(ind), 2);

                x_max = max(x_max, x_body);
                y_max = max(y_max, y_body);

            end;

        end;


        shift_x = max(x_max);
        shift_y = max(y_max);

        %shift_z = max(z_body);


        if(max(shift_x, shift_y) >= SAR.Tune_par.Rad)
            msgbox ('Dimension mismatch! Body is larger than coil!');
            return;
        end;

        shift = [0; shift_y + pillow_shift; 0];
        
%case min for head model, 
%where nose points in positive direction
    case 0
        x_min = 0;
        y_min = 0;
        %z_max = 0;

        for ind = 1:length(i_z)

            if(i_z(ind) >= z_min)

                x_body = RHBM.r (i_x(ind), i_y(ind), i_z(ind), 1);
                y_body = RHBM.r (i_x(ind), i_y(ind), i_z(ind), 2);

                x_min = min(x_min, x_body);
                y_min = min(y_min, y_body);

            end;

        end;


        shift_x = min(x_min);
        shift_y = max(y_min);

        %shift_z = max(z_body);


        if(max(abs(shift_x, shift_y)) >= SAR.Tune_par.Rad)
            msgbox ('Dimension mismatch! Body is larger than coil!');
            return;
        end;

        shift = [0; shift_y - pillow_shift; 0];
end;
