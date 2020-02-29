function y = SparseCode(params)
% SPARSECODE - AUXILIARY FUNCTION
%  Code an input sequence on an overcomplete dictionary using OMP.
%
%  Inputs:
%   params : Struct containing parameters for the K-SVD dictionary training
%            algorithm.
%     x         : 3D matrix containing sequence to be sparsely coded.
%     blocksize : 1x3 vector specifying the dimensions for the 3D patches
%                 used in the training and coding dictionary.
%     dict      : Matrix containing dictionary D. Dictionary atoms are
%                 represented as matrix rows of size
%                 prod(params.blocksize).
%     Edata     : Maximum L2 error allowed in sparse coding for each patch.
%
%  Outputs:
%   y : 3D matrix containing sparsely coded sequence.
%
% *IMPORTANT*
%  This function is modified from ompdenoise3.m and requires the use of
%  functions im2colstep.m, col2imstep.m, omp2.m, countcover.m, remove_dc.m
%  and add_dc.m. All can be found in
%  
%  ksvdbox13 and ompbox10
%  (http://www.cs.technion.ac.il/~ronrubin/software.html)  
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

x = params.x;
D = params.dict;
blocksize = params.blocksize;
maxatoms = floor(prod(blocksize)/2);
sigma = params.Edata;
G = D'*D;


% the output signal
y = zeros(size(x));

for k = 1:size(y,3)-blocksize(3)+1
    if mod(k,5) == 0
        completed = (k/(size(y,3)-blocksize(3)+1))*100;
        fprintf('...%2.1f%%',completed);
    end
    for j = 1:size(y,2)-blocksize(2)+1      
        % the current batch of blocks
        blocks = im2colstep(x(:,j:j+blocksize(2)-1,k:k+blocksize(3)-1),blocksize,[1 1 1]);

        % remove DC
        [blocks, dc] = remove_dc(blocks,'columns');

        % Sparse code blocks using OMP
        gamma = omp2(D'*blocks,sum(blocks.*blocks),G,sigma,'maxatoms',maxatoms,'checkdict','off');

        cleanblocks = add_dc(D*gamma, dc, 'columns');

        cleanvol = col2imstep(cleanblocks,[size(y,1) blocksize(2:3)],blocksize,[1 1 1]);
        y(:,j:j+blocksize(2)-1,k:k+blocksize(3)-1) = y(:,j:j+blocksize(2)-1,k:k+blocksize(3)-1) + cleanvol;
            
    end
end

% average the denoised and noisy signals
cnt = countcover(size(x),blocksize,[1 1 1]);
y = y./cnt;

