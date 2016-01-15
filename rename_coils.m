% rename Coils  in folder pat_to_folder


path_to_folder = '~/Desktop/MARIE-master/data/coils';
cd (path_to_folder);



%% parsing filenames

const_name = 'Birdcage_newl=';
new_const_name = 'Birdcage_new_l';

n_rad_old = 'rad=';
n_rad_new = '_rad';
ext = {'.geo', '.msh', '.smm'};


%ls;

%% setting sizes 

r_min = 0.1;  %size in meters
r_max = 0.20; 
l_min = 0.1;
l_max = 0.22;

N_l = 10;
N_r = 10;

d_r = (r_max - r_min) / N_r;
d_l = (l_max - l_min) / N_l;



%% renaming variables

for i = 0:(N_r-1)   %loop over radius
    r = r_min + i * d_r;
    
    for j = 0:(N_l-1)
        
        l = l_min + j* d_l;
        
        old_name = strcat(const_name, num2str(l));
        old_name = strcat(old_name, n_rad_old);
        old_name = strcat(old_name, num2str(r));
        
        new_name = strcat(new_const_name, num2str(l));
        new_name = strcat(new_name, n_rad_new);
        new_name = strcat(new_name, num2str(r));
        
        for k =1:length(ext)
            
            curr_old_name = strcat(old_name, ext{k});
            curr_new_name = strcat(new_name, ext{k});
                       
            if exist(curr_old_name, 'file')
                
                movefile(curr_old_name, curr_new_name);
                disp(curr_new_name);
                
                if ( ext{k} == '.smm')
                   
                end;
            end;
            
        end;
    end;
end;

%% change reference in .smm


for i = 0:(N_r-1)   %loop over radius
    r = r_min + i * d_r;
    
    for j = 0:(N_l-1)
        
        l = l_min + j* d_l;
        
        
        new_name = strcat(new_const_name, num2str(l));
        new_name = strcat(new_name, n_rad_new);
        new_name = strcat(new_name, num2str(r));
        
            
        curr_new_name = strcat(new_name, ext{3});
                       
            if exist(curr_new_name, 'file')
                
                disp(curr_new_name);
                
                fid = fopen(curr_new_name, 'r');
                
                disp(fgetl(fid));
            end;
            
    end;
end;


%movefile(old_name, newname);

