function new_seq = SeqExpand(block, seq)
% SEQEXPAND - AUXILIARY FUNCTION
%  Expand a sequence on all sequence boundaries by the blocksize.
%
%  Inputs:
%   block : 1x3 vector defining 3D patch sizes. Can also be an integer for
%           cubic patches.
%   seq   : 3D matrix with sequence to expand.
%
%  Output:
%   new_seq : 3D matrix with expanded sequence.


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


if size(block) == [1 1]
    ext_r = block-1;
    ext_c = block-1;
    if size(seq,3) == 1
        ext_t = 1;
    else
        ext_t = block-1;
    end
else
    ext_r = block(1)-1;
    ext_c = block(2)-1;
    ext_t = block(3)-1;
end

% Old sequence dimensions
old_dim_r = size(seq,1);
old_dim_c = size(seq,2);
old_dim_t = size(seq,3);

% New sequence dimensions
new_dim_r = old_dim_r + ext_r*2;
new_dim_c = old_dim_c + ext_c*2;
new_dim_t = old_dim_t + ext_t*2;

% row and column extension
repeated_seq1 = [seq,seq,seq;seq,seq,seq;seq,seq,seq];

% temporal extension
repeated_seq2(:,:,1:old_dim_t) = repeated_seq1;
repeated_seq2(:,:,old_dim_t+1:2*old_dim_t) = repeated_seq1;
repeated_seq2(:,:,2*old_dim_t+1:3*old_dim_t) = repeated_seq1;

new_seq = repeated_seq2((old_dim_r-ext_r+1):(2*old_dim_r+ext_r),...
    (old_dim_c-ext_c+1):(2*old_dim_c+ext_c),(old_dim_t-ext_t+1):(2*old_dim_t+ext_t));
end