function train_patches = extractTraining(x,paramKSVD)
% train_patches = extractTraining(x,paramKSVD)
%
% Extracts training patches from a regular grid on an image
%
% INPUTS
%   x...                        Image from which to extract training data
%   paramKSVD.
%     blocksize...              Patch size
%     trainnum...               Number of training patches required
%
% OUTPUTS
%    train_patches...           Matrix with training patches as columns

%  Jose Caballero
%  Department of Computing
%  Imperial College London
%  jose.caballero06@gmail.com
%
%  May 2014

p = ndims(x);

if p == 2
    blocksize = [paramKSVD.blocksize paramKSVD.blocksize];
else if p == 3
        blocksize = [paramKSVD.blocksize paramKSVD.blocksize paramKSVD.blocksize];
    end
end

ids = cell(p,1);
[ids{:}] = reggrid(size(x)-blocksize+1, paramKSVD.trainnum, 'eqdist');

train_patches = sampgrid(x,blocksize,ids{:});

train_patches = train_patches - repmat(mean(train_patches,1),[size(train_patches,1) 1]);

end