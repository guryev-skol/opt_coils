function Load_RHBM(modelname, modelpath)
%function Load_RHBM(modelname, modelpath)
%function loads RHBM model to RHBM structure

global RHBM;

% call the function to import the RHBM
if ~(strcmp(modelname,'No Model Selected'))
    vsmfile = strcat(modelpath,modelname);
    [RHBM] = Import_RHBM(vsmfile);
else
    fprintf(1, '\n\n Warning: No model selected -- navigate and chose a valid model\n\n');
end;


