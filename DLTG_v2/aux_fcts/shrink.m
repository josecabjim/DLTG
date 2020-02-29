function out = shrink(in, blocksize)
% out = shrink(in, blocksize)
%
% Shrink image back to original size from wrap-around expansion.
%
% INPUTS
%   in...                       Input image to shrink
%   blocksize...                Size of expansion blocksize-1
%
% OUTPUTS
%   out...                      Shrunk image

%  Jose Caballero
%  Department of Computing
%  Imperial College London
%  jose.caballero06@gmail.com
%
%  May 2014

if ndims(in) == 2
    out = in(blocksize:(end-blocksize+1),(blocksize):(end-blocksize+1));
else   
    out = in(blocksize:(end-blocksize+1),blocksize:(end-blocksize+1),blocksize:(end-blocksize+1));
end

end