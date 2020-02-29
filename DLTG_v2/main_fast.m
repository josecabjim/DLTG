%% -- DLTG demo v2
% This script is a demo code to demonstrate the use of Dictionary Learning
% in dynamic MRI data reconstruction. Different versions of this code were 
% used to produce the results shown in the following papers:
%
% J. Caballero, A. N. Price, D. Rueckert and J. V. Hajnal, "Dictionary 
% learning and time sparsity for dynamic MR data reconstruction", Medical 
% Imaging, IEEE Transactions on, vol.33, no.4, pp. 979,994, April 2014.
% 
% J. Caballero, D. Rueckert and J. V. Hajnal, "Dictionary learning and time 
% sparsity in dynamic MRI." Medical Image Computing and Computer-Assisted 
% Intervention, MICCAI, pp. 256-263, 2012.
%
% For extended use instructions please read the readme.txt file.
%
% Script parameters:
%
%   x...                         Original (fully-sampled) input image (2D or 3D)
%   paramKSVD.
%      blocksize...              Patch and atom size (define only 1st dim)
%      dictsize...               Number of dictionary atoms
%      iternum...                Number of KSVD iterations (if = 0, no training)
%      trainnum...               Number of training patches
%      Edata...                  Maximum error allowed in patch
%                                representation
%      maxatoms...               Maximum number of atoms used per patch
%      analyse...                if = 1 will output sparse coding analysis data
%   paramDLTG.
%      q...                      Noise regularisation parameter
%      maxit_dltg...             Maximum number of DLTG outer iterations
%      maxit_tg...               Maximum number of TG inner iterations
%      nabla...                  Regularisation parameter for TG sparsity
%   ksnr...                      SNR of k-space produced by added noise

%  Jose Caballero
%  Department of Computing
%  Imperial College London
%  jose.caballero06@gmail.com
%
%  May 2014

close all;
clear all;
clc;

fprintf(['\n --------------------------------\n']);
fprintf([' - DLTG demo v2 -\n']);
fprintf([' --------------------------------\n\n']);

%% Initialise data and parameters
load data_tmi_fast;
 
x = seq/max(abs(seq(:)));

[Nx,Ny,Nt] = size(x);

% KSVD parameters
paramKSVD.blocksize = 4;
paramKSVD.dictsize = 200; % May be rounded up
paramKSVD.iternum = 0;
paramKSVD.trainnum = 1e5;
paramKSVD.sigma = 0.02; % epsilon in TMI paper
paramKSVD.maxatoms = 10;
paramKSVD.analyse = 1;

% DLTG algorithm parameters
paramDLTG.q = 10^(-4);
paramDLTG.maxit_dltg = 100;
paramDLTG.maxit_tg = 10;
paramDLTG.nabla = 4e-4;

ksnr = 1e6; % Simulated k-space SNR

%% Simulation preparation
X = im2k(x);

% Generate undersampling mask
% --- Insert code here to simulate different sampling masks ---

% Simulate undersampling and add noise
X_u = X.*mask;
Ps = (sum(abs(X_u(:)).^2)) / (sum(mask(:)));
Pn = Ps/(10^(ksnr/10)); % Noise power
noise = sqrt(Pn/2)*(randn(Nx,Ny,Nt) + 1i*randn(Nx,Ny,Nt));
X_u_n = (X+noise).*mask;

% Undersampled and noisy image
x_u_n = k2im(X_u_n);

% Regularisation parameter
nu = min(paramDLTG.q/sqrt(Pn/2),1e20);

%% DLTG iterative reconstruction
x_dltg = x_u_n;
for it_dltg = 1:paramDLTG.maxit_dltg 
    fprintf(['\n - DLTG iteration ',num2str(it_dltg),'\n']);
    fprintf([' -------------------\n']);
    
    % Train dictionary with KSVD
    [Dict, AnalysisTrain] = KSVDtrain(x_dltg, paramKSVD);

    % Sparse code with OMP
    [x_DL, AnalysisCode] = OMPcode(x_dltg, Dict, paramKSVD);

    % Enforce data consistency
    X_DL = im2k(x_DL);
    X_DL_kcons = X_DL;
    X_DL_kcons(mask==1) = (X_DL(mask==1) + nu*X_u_n(mask==1))/(1+nu);
    x_DL_kcons = k2im(X_DL_kcons);

    % TV in time (TG) denoise
    x_TG_kcons = x_DL_kcons;
    fprintf('\n --- TG iteration: ');
    for it_tg = 1:paramDLTG.maxit_tg
        fprintf([num2str(it_tg),'.']);
        
        x_TG_kcons_p = angle(x_TG_kcons);
        x_TG_kcons_m = abs(x_TG_kcons);

        % Denoise magnitude
        [x_TG_m,J] = denoiseTV(x_TG_kcons_m(:).',paramDLTG.nabla,40,D,Dt);
        x_TG_m = reshape(x_TG_m,Nx,Ny,Nt);

        % Recombine complex signal
        x_TG = x_TG_m .* exp(1i*x_TG_kcons_p);

        % Enforce data consistency
        X_TG = im2k(x_TG);
        X_TG_kcons = X_TG;
        X_TG_kcons(mask==1) = (X_TG(mask==1) + nu*X_u_n(mask==1))/(1+nu);
        x_TG_kcons = k2im(X_TG_kcons);
    end
    
    x_dltg = x_TG_kcons;
    fprintf('\n');
    
    % Check result
    PSNR(it_dltg) = evaluatePSNR(x,x_dltg);
    figure(1);plot(PSNR);
    figure(2);imshow(abs([x(:,:,1),x_dltg(:,:,1)]),[])
end


