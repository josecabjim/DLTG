function X = im2k(x)
% X = im2k(x)
%
% Transform from image domain to k-space.
%
% INPUTS
%   x...            Image domain data (2D or 3D)
%
% OUTPUTS
%   X...            k-space data (2D or 3D)

%  Jose Caballero
%  Department of Computing
%  Imperial College London
%  jose.caballero06@gmail.com
%
%  May 2014

for t = 1:size(x,4)
    for c = 1:size(x,3)        
        X1 = fftshift(fft(ifftshift(x(:,:,c,t)),[],1));        
        X2 = fftshift(fft(ifftshift(X1),[],2));
        X(:,:,c,t) = 1/sqrt(size(x,1)*size(x,2)) * X2;
    end
end

end