function x = k2im(X)
% x = k2im(X)
%
% Transform from k-space to image domain.
%
% INPUTS
%   X...            k-space data (2D or 3D)
%
% OUTPUTS
%   x...            Image domain data (2D or 3D)

%  Jose Caballero
%  Department of Computing
%  Imperial College London
%  jose.caballero06@gmail.com
%
%  May 2014

for t = 1:size(X,4)
    for c = 1:size(X,3)
        x1 = fftshift(ifft(ifftshift(X(:,:,c,t)),[],1));
        x2 = fftshift(ifft(ifftshift(x1),[],2));
        x(:,:,c,t) = sqrt(size(X,1)*size(X,2)) * x2;
    end
end

end