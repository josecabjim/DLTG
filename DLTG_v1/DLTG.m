function [seq_dltg, PSNR_dltg] = DLTG(params, options, seq, mask, S_zf, D, Dt)
% DLTG
%  Provided an undersampled sequence k-space and the undersmapling mask 
%  used, this function will reconstruct a sequence and evaluate the
%  reconstruction performance using the DLTG algorithm as proposed in 
%
%  J. Caballero, D. Rueckert and J. V. Hajnal,
%  ?Dictionary learning and time sparsity for dynamic MRI,?
%  Proceedings of the 15th International Conference on MICCAI,
%  vol. 1, pp. 256-263, Nice, France, 1-5 October 2012.
%
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


%% Initialisation

[Nx, Ny, Nt] = size(seq);

% Initialise parameters and options
[params, options] = CheckDLTGInputs(params, options, seq, mask, S_zf, D, Dt);

% Weight for k-space consistency (eq 5)
q = 0.005; % Optimal
v = q/(sqrt(options.Pn));

% Initialise algorithm with zero-filled sequence
for t = 1:Nt
    seq_zf(:,:,t) = abs(ifft2(S_zf(:,:,t))*sqrt(Nx*Ny));
end
seq_dltg = seq_zf;

% Calculate initial PSNR
PSNR_zf = PSNR(seq,seq_zf);
PSNR_dltg(1) = PSNR_zf;

%% Main Loop - Outer iterations

maxIt_DLTG = options.iterdltg;
for iteration_DLTG = 1:maxIt_DLTG
    ProgressDLTG(iteration_DLTG,maxIt_DLTG); % Display progress

    %% Subproblem 1) DL training and sparse coding

    % Update epsilon of eq 2 (Fixed epsilon is much slower)
    params.Edata = sqrt(prod(params.blocksize)*mean(abs(seq_dltg(:)-seq(:)).^2)); % Variable epsilon - As in paper
    % params.Edata = 0.05; % Fixed epsilon

    % Sequence expansion to account for wrap around edges
    params.x = SeqExpand(params.blocksize, seq_dltg);
    
    % Extract training patches
    params.data = ExtractTraining(params);

    % K-SVD dictionary training (eq 2)
    fprintf('K-SVD training... \n');
    params.dict = ksvd(params,'',0,'tr');
    fprintf(['\n','DL training done! \n\n'])
    
    % OMP sparse coding under D (eq 3)
    fprintf('DL sparse coding');
    seq_DL_approx = SparseCode(params);
    fprintf('... done! \n\n')
    
    % Shrink the result back to the original sequence size
    seq_shrinked = SeqShrink(params.blocksize, seq_DL_approx);

    % Enforce data consistency (eq 5)
    seq_dl = DataConsistency(seq_shrinked, S_zf, mask, v);
    
    %% Subproblem 2) Filtering for TG sparsity
    
    fprintf('TG filtering')

    % Initialise solution with the DL solution
    seq_tg = seq_dl;
    
    maxIt_TG = 10;
    for iteration_TG = 1:maxIt_TG
        ProgressTG(iteration_TG, maxIt_TG);
        
        % Update lambda of eq 4
        lambda = sqrt(mean(abs(seq_tg(:)-seq(:)).^2))/2; % As in paper
        % lambda = 0.001; % Fixed lambda
        
        % Sparsify TG (eq 4)
        seq_tg_approx_vector = DenoiseTG(seq_tg(:).',lambda,40,D,Dt);
        seq_tg_approx = reshape(seq_tg_approx_vector,Nx,Ny,Nt);

        % Enforce data consistency (eq 5)
        seq_tg = DataConsistency(seq_tg_approx, S_zf, mask, v);

    end
    fprintf('... done! \n\n');

    % Update solution
    seq_dltg = seq_tg;
    PSNR_dltg(iteration_DLTG+1) = PSNR(seq, seq_dltg);

    %% Display current results
    
    if options.display == 1  
        DisplayResults(seq, seq_zf, seq_dltg, iteration_DLTG,...
            PSNR_dltg, maxIt_DLTG)
    end           

end

end