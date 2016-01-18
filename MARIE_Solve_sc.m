function MARIE_Solve_sc()
%function MARIE_Solve_sc()
%reproduces the work of MARIE_Solve for a shorted birdcage

% get global variables
global RHBM;
global COIL;
global SOL;
global SAR;

tolerance = 1e-3;
freq = [300e6];


% get frequency data
numfreqs = length(freq);
freqmin = min(freq);
if (isempty(freqmin))
    errordlg('Wrong Frequency Range -- Please correct', 'Error');
end
if (numfreqs > 1) % frequency sweep
    freqmax = str2num(get(handles.Freq_Max_Edit, 'String'));
    if (isempty(freqmax)) || (freqmax <= freqmin)
        errordlg('Wrong Frequency Range -- Please correct', 'Error');
    end
    
    if get(handles.Freq_Logscale_Select,'Value') % logscale
        if (freqmin == 0)
            freqmin = min( [freqmax/100, 1e-6]); % avoid log of zero
        end
        fvalues = logspace(log10(freqmin),log10(freqmax),numfreqs);

    else % linear scale
        fvalues = linspace(freqmin,freqmax,numfreqs);
    end
else
    fvalues = freqmin; % single frequency
end
        
% get tolerance
tol = tolerance;

% set the values to compute
flags = ones(9,1);
flags(9,1) = 0;

if strcmp(RHBM.name,'No Model Selected');

    validcoil = 1;

    switch COIL.type
        case 'S'
            
            % get positions of the coil elements
            xmin = min(COIL.node(:,1));
            xmax = max(COIL.node(:,1));
            ymin = min(COIL.node(:,1));
            ymax = max(COIL.node(:,1));
            zmin = min(COIL.node(:,1));
            zmax = max(COIL.node(:,1));
            
        case 'W'
            
            % get positions of the coil elements
            xmin = min(COIL.Pcoil(:,1));
            xmax = max(COIL.Pcoil(:,1));
            ymin = min(COIL.Pcoil(:,2));
            ymax = max(COIL.Pcoil(:,2));
            zmin = min(COIL.Pcoil(:,3));
            zmax = max(COIL.Pcoil(:,3));

        otherwise
            
            validcoil = 0;
            
    end

    if validcoil
        % create a new grid
        dx = 0.005; % 5mm grid
        % number of voxels in each direction
        nX = ceil((xmax - xmin)/dx)+1;
        nY = ceil((ymax - ymin)/dx)+1;
        nZ = ceil((zmax - zmin)/dx)+1;
        
        % make sure we cover the whole domain (extra voxel in case non exact)
        xnew = xmin-dx:dx:xmin+nX*dx;
        ynew = ymin-dx:dx:ymin+nY*dx;
        znew = zmin-dx:dx:zmin+nZ*dx;
        
        % generate the 3D grid and assign free-space to the grid
        RHBM.r = grid3d(xnew,ynew,znew);
        [L,M,N,~] = size(RHBM.r);
        RHBM.epsilon_r = ones(L,M,N);
        RHBM.sigma_e = zeros(L,M,N);
        RHBM.rho = zeros(L,M,N);
        RHBM.name = 'Free Space';
        
    else
        flags(2) = 0;        
    end

else
    % we have RHBM
    flags(3) = 1;

end


% solve the system
[ZP,Jc,Jb,Sb,Eb,Bb,Gsar,Pabs] = MR_Solver(RHBM,COIL,fvalues,tol,flags);

SOL.Zparam = ZP;
SOL.Jcoil = Jc;
SOL.Jsol = Jb;
SOL.Esol = Eb;
SOL.Bsol = Bb;
SOL.Ssol = Sb;
SOL.Gsar = Gsar;
SOL.Pabs = Pabs;
SOL.freq = fvalues;

% S = [];
% S = sum(SOL.Ssol, 4);
% 
% 
% [SAR.maxSAR, I] = max(S(:));
% [SAR.ind(1), SAR.ind(2), SAR.ind(3)] = ind2sub(size(S), I);
% 
% SAR.maxSAR_cut_x = S(SAR.ind(1), :, :);
% SAR.maxSAR_cut_y = S(:, SAR.ind(2), :);
% SAR.maxSAR_cut_z = S(:, :, SAR.ind(3));
% 
% save(filename, 'SAR');
