% DLTG DEMO - MAIN SCRIPT
%  
%  This is a demo for the testing of the Dictionary Learning Temporal
%  Gradient (DLTG) algorithm for the reconstruction of accelerated dynamic 
%  MR data presented in 
%
%  J. Caballero, D. Rueckert and J. V. Hajnal,
%  "Dictionary learning and time sparsity for dynamic MRI,"
%  Proceedings of the 15th International Conference on MICCAI,
%  vol. 1, pp. 256-263, Nice, France, 1-5 October 2012.
%
%  Running this script will launch a reconstruction example. The data used
%  for this example has been saved into data1.mat, containing:
%    - seq     : An original MR cardiac cine sequence (magnitude only and
%                normalised).
%    - mask    : An undersampling mask corresponding to a 4x acceleration
%    - [D, Dt] : Precomputed matrices necessary for TV filtering.
%
%  Feel free to try your own data and share your results!
%
%  Please report any bugs or problems.


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


clear all

%% Demo options and K-SVD parameters

% Test data
load('data1.mat'); % Contains seq and mask
[Nx, Ny, Nt] = size(seq);

% General options
options.kSNRdb = 100; % Added noise power in k-space
options.display = 1; % Show a tracking of the results
options.iterdltg = 7; % Number of DLTG outer iterations

% K-SVD parameters
params.blocksize = [5 5 5]; % Patch dimensions
params.dictsize = 300; % Number of dictionary atoms
params.trainnum = 5000; % Number of training patches
params.iternum = 10; % Number of K-SVD iterations

%% Undersample sequence in k-space and add noise

% Compute true (fully-sampled) k-space
for t = 1:Nt
   S(:,:,t) = fft2(seq(:,:,t))/sqrt(Nx*Ny);
end

% Add AWGN noise in k-space
Ps = mean(abs(S(:)).^2);
kSNRl = 10^(options.kSNRdb/10);
options.Pn = Ps/kSNRl;
sigma = sqrt(options.Pn); %Noise variance
S_n = S + (sigma/sqrt(2)).*(randn(size(S)) + 1i*randn(size(S)));

% Compute zero-filled k-space sequence
S_zf = S_n.*mask;

%% Reconstruct using DLTG
[seq_dltg, PSNR_dltg] = DLTG(params, options, seq, mask, S_zf, D, Dt);
