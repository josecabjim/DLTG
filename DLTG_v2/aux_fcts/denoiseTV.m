function [x,J] = denoiseTV(y,lambda,Nit,D,Dt)
% [x,J] = denoiseTV(y,lambda,Nit,D,Dt)
% 
% Temporal gradient filtering (denoising) using iterative clipping algorithm.
%
% INPUTS
%   y...                    Noisy signal (row vector)
%   lambda...               Regularization parameter
%   Nit...                  Number of iterations
%   [D, Dt]...              Finite difference matrix and its transpose
%                           obtained with the genD.m function. It is highly
%                           recommended that these matrices are precomputed
%                           and stored as generating them is time
%                           consuming.
% 
% OUTPUTS
%   x...                    Result of denoising
%   J...                    Objective function

%  Jose Caballero
%  Department of Computing
%  Imperial College London
%  jose.caballero06@gmail.com
%
%  May 2014

J = zeros(1,Nit); % objective function
N = length(y);
z = zeros(1,N); % initialize z
alpha = 4;
T = lambda/2;
for k = 1:Nit
    x = y.' - Dt*z.'; x = x(:).';
    J(k) = sum(abs(x-y).^2) + lambda * sum(abs(D*x.'));
    z = z(:) + 1/alpha * D*x(:); z = z(:).';
    z = max(min(z,T),-T); % clip(z,T)
end