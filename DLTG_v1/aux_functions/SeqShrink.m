function new_seq = SeqShrink(block, seq)
% SEQSHRINK - AUXILIARY FUNCTION
%  Shrink a sequence on all sequence boundaries by the blocksize. Undoes
%  the effect of SEQEXPAND.
%
%  Inputs:
%   block : 1x3 vector defining 3D patch sizes. Can also be an integer for
%           cubic patches.
%   seq   : 3D matrix with sequence to shrink.
%
%  Output:
%   new_seq : 3D matrix with shrunk sequence.


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
    ext_t = block-1;
else
    ext_r = block(1)-1;
    ext_c = block(2)-1;
    ext_t = block(3)-1;
end

new_seq = seq((ext_r+1):(end-ext_r),(ext_c+1):(end-ext_c),(ext_t+1):(end-ext_t));

end