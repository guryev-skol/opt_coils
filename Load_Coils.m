function Load_Coils(modelname, modelpath)
% function loads coil of interest (coil_name) to
% optimizer optimize_coils()


global COIL;
global SAR;


%% loading the coil

SAR.Tune_par.Rad = cell2mat(getRadius(modelname));

% call the function to import the RHBM
if ~(strcmp(modelname,'No Model Selected'))
    coilfile = strcat(modelpath,modelname);
    last = length(modelname);
    extension = modelname(last-3:last);
        if (strcmp(extension,'.smm'))
            [COIL] = Import_COIL(coilfile);
        end
        if (strcmp(extension,'.wmm'))
            [COIL] = Import_COIL(coilfile);
        end
else
    fprintf(1, '\n\n Warning: No model selected -- navigate and chose a valid model\n\n');
end


%% update SAR structure


l_min = min(COIL.node(3,:));
l_max = max(COIL.node(3,:));
l = l_max - l_min;

SAR.Coil_name = COIL.name;
SAR.Tune_par.thickness = COIL.Thickness;
SAR.Coil_type = COIL.type;
SAR.Tune_par.Len = l;
%SAR.Tune_par.Rad = getRad
