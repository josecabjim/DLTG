function train_data = ExtractTraining(params)
% EXTRACTTRAINING - AUXILIARY FUNCTION
%  Extract 3D training patches from a regular grid in a 3D matrix.
%
%  Inputs:
%   params : Struct containing parameters for the K-SVD dictionary training
%            algorithm.
%     x         : 3D matrix from which to extract training patches.
%     blocksize : 1x3 vector specifying the dimensions for the 3D patches
%                 extration.
%     trainnum  : Integer specifying the number of training patches to
%                 extract.
%
%  Output:
%   train_data : 3D matrix of dimensions
%                [prod(params.blocksize),params.trainnum] containing
%                training 3D patches as matrix columns. All training
%                patches have 0 DC component.
%
% *IMPORTANT*
%  This function is modified from ksvddenoise.m and requires the use of
%  functions reggrid.m and sampgrid.m. All can be found in
%  
%  ksvdbox13 (http://www.cs.technion.ac.il/~ronrubin/software.html)
%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  August 2009


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


% If test data exists, clear it
if (isfield(params,'testdata'))
  params = rmfield(params,'testdata');
end

% Define training patch extraction grid
ids = cell(3,1);
[ids{:}] = reggrid(size(params.x)-params.blocksize+1, params.trainnum, 'eqdist');

% Extract training patches
train_data = sampgrid(params.x,params.blocksize,ids{:});

% Remove block DC to conserve memory
blocksize = 2000;
for i = 1:blocksize:size(train_data,2)
  blockids = i : min(i+blocksize-1,size(train_data,2));
  train_data(:,blockids) = remove_dc(train_data(:,blockids),'columns');
end

end