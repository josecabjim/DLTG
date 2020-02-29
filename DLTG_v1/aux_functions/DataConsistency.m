function seq_out = DataConsistency(seq_in, S_zf, mask, v)
% DATACONSISTENCY - AUXILIARY FUNCTION
%  Enforce data consistency in k-space between a given input sequence and
%  the originally acquired (undersampled) k-space. Non-acquired samples in
%  k-space will not be modified, whereas acquired one will be replaced by a
%  weighted combination between the acquired values and the k-space from
%  the input sequence.
%
%  Inputs:
%   seq_in : 3D matrix containing the input sequence that is subject to
%            k-space consistency.
%   S_zf   : 3D binary matrix representing the undersampled k-space
%            acquired. Dimensions have to be the same as size(seq).
%   mask   : 3D binary matrix representing the undersampling mask used.
%            Dimensions have to be the same as size(seq).
%   v      : Integer defining the weighting between the input k-space and
%            the acquired k-space at acquired k-space samples.
%
%  Outputs:
%   seq_out : 3D matrix containing the sequence after enforcing k-space
%             data consisntency.


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


[Nx,Ny,Nt] = size(seq_in);

for t = 1:Nt
    % Current solution k-space
    S(:,:,t) = fft2(seq_in(:,:,t))/sqrt(Nx*Ny);

    % Update k-space by replacing samples that were originally acquired
    % (eq 5)
    for x = 1:Nx
        for y = 1:Ny
            if mask(x,y,t) == 1 
                S_consist(x,y,t) = (S(x,y,t)+v*S_zf(x,y,t))/(1+v); 
            else 
                S_consist(x,y,t) = S(x,y,t); 
            end 
        end
    end

    %Go back to signal space
    seq_out(:,:,t) = abs(ifft2(S_consist(:,:,t))*sqrt(Nx*Ny));
end

end