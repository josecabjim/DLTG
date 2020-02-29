function [params, options] = CheckDLTGInputs(params, options, seq, mask, S_zf, D, Dt)
% CHECKDLTGINPUTS - AUXILIARY FUNCTION
%  Check the parameters that constitute the input to the DLTG function.
%  Detect errors if inputs are missing or invalid, or define with default
%  values when missing and possible.
%
%  Inputs:
%   seq     : 3D matrix containing the sequence of original (fully-sampled) 2D 
%             frames. Has to be normalised such that max(seq(:)) = 1.
%   mask    : 3D binary matrix representing the undersampling mask used.
%             Dimensions have to be the same as size(seq).
%   S_zf    : 3D matrix of zero-filled k-space. Dimensions have to be the same
%             as size(seq).
%   [D, Dt] : Matrices needed for TG filtering. Refer to GenD.m for more
%             information on how to generate them.
%
%   Optional
%   --------
%   params : Struct containing parameters for the K-SVD dictionary training
%            algorithm.
%     blocksize : 1x3 vector specifying the dimensions for the 3D patches
%                 used in the training and coding dictionary.
%                 (Default = [5,5,5])
%     dictsize  : Integer defining the number of dictionary atoms.
%                 (Default = 300)
%     trainnum  : Integer specifying the number of training patches.
%                 (Default = 5000)
%     iternum   : Integer representing the number of training iterations.
%                 (Default = 10)
%   options : 
%     kSNRdb    : Integer specifying the input SNR in k-space. (Default = 100)
%     display   : Binary variable to display reconstruction progress (1) or
%                 not (0). (Default = 1);
%     iterdltg  : Integer determining DLTG outer iterations. (Default = 7)
%
%
%  Outputs:
%   seq_dltg  : 3D matrix of size size(seq) with the DLTG reconstruction.
%   PSNR_dltg : Integer with reconstruction PSNR.


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


[Nx, Ny, Nt] = size(seq);

disp('-------------------------------')
fprintf(['\n','Starting DLTG reconstruction','\n']);
disp('-------------------------------')

%% Display test data characteristics

fprintf(['\n','Test data parameters:','\n']);
disp('-------------------------------');

disp(['- Sequence dimensions: ',num2str(size(seq,1)),'x',...
    num2str(size(seq,2)),'x',num2str(size(seq,3))]);

disp(['- Sampling ratio: ',num2str(sum(mask(:))/numel(mask(:)))]);

if isfield(options,'kSNRdb')==0
    disp('- K-Space SNR: 100dB (default)');
    options.kSNRdb = 100;
else
    disp(['- K-Space SNR: ',num2str(options.kSNRdb),'dB']);
end

for t = 1:Nt
    seq_zf(:,:,t) = abs(ifft2(S_zf(:,:,t))*sqrt(Nx*Ny));
end
PSNR_zf = PSNR(seq,seq_zf);

fprintf('- Initial PSNR: %2.2fdB',PSNR_zf);fprintf('\n');

%% Display general options

fprintf(['\n','General options: \n']);
disp('-------------------------------')

% Check number of DLTG iterations
if isfield(options,'iterdltg')==0
    disp('- Number of DLTG iterations: 10 (default)');
    params.iterdltg = 10;
else
    disp(['- Number of DLTG iterations: ', num2str(options.iterdltg)]);
end

% Check if results have to be displayed at each iteration
if isfield(options,'display')==0
    options.display = 1;
    disp('- Progress displayed');
else
    if options.display == 0
        disp('- Progress not displayed (This might take a while)');
    else
        disp('- Progress displayed');
    end
end

%% Display K-SVD parameters

fprintf(['\n','K-SVD parameters: \n']);
disp('-------------------------------')

% Check patch sizes
if isfield(params,'blocksize')==0
    disp('- Patch blocksize: 5x5x5 (default)');
    params.blocksize = [5 5 5];
else
    disp(['- Patch blocksize: ', num2str(params.blocksize(1)),'x',...
    num2str(params.blocksize(2)),'x',...
    num2str(params.blocksize(3))]);
end

% Check dictionary size
if isfield(params,'dictsize')==0
    disp('- Dictionary size: 300 (default)');
    params.dictsize = 300;
else
    disp(['- Dictionary size: ', num2str(params.dictsize)]);
end

% Check number of training patches
if isfield(params,'trainnum')==0
    disp('- Number of training atoms: 5000 (default)');
    params.trainnum = 5000;
else
    disp(['- Number of training atoms: ', num2str(params.trainnum)]);
end

% Check number of K-SVD iterations
if isfield(params,'iternum')==0
    disp('- Number of training iterations: 10 (default)');
    params.iternum = 10;
else 
    disp(['- Number of training iterations: ', num2str(params.iternum)]);
end

% Maximum value in reconstruction
params.maxval = max(seq);

% Initial K-SVD dictionaries are DCT
params.initdict = InitialiseD(params);

% Check that matrices D are of the correct dimensions
if (prod(size(seq)) ~= size(D,1)) || (prod(size(seq)) ~= size(Dt,1))
    disp(['*WARNING* Revise matrices D. These can be generated using '...
        'the function genD.m for the correct sequence dimensions.'])
end

end