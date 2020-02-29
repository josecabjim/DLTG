function DisplayResults(seq, seq_zf, seq_dltg, iteration_DLTG,...
    PSNR_dltg, maxIt_DLTG)
% DISPLAYRESULTS - AUXILIARY FUNCTION
%  Display results comparing an original sequence with its reconstruction
%  ans its zero-filled version at a given DLTG iteration.
%
%  Inputs:
%   seq            : 3D matrix containing the sequence of original
%                    (fully-sampled) 2D frames.
%   seq_zf         : 3D matrix of zero-filled sequence. Dimensions have to
%                    be the same as size(seq).
%   seq_dltg       : 3D matrix representing the reconstructed sequence.
%                    Dimensions have to be the same as size(seq).
%   iteration_DLTG : Integer defining the current DLTG iteration.
%   PSNR_dltg      : Current reconstruction PSNR.
%   maxIt_DLTG     : Integer defining the maximum number of DLTG
%                    iterations.
%
%  Outputs:
%   seq_dltg  : 3D matrix of size size(seq) with the DLTG reconstruction.
%   PSNR_dltg : Integer with reconstruction PSNR.


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


[Nx,Ny,Nt] = size(seq);

% Draw dashed line on original sequence
seq_dash = seq;
dashed = 1;
col_ind = 1:10;
while dashed(end) < Ny-20
    dashed = [dashed, col_ind];
    col_ind = col_ind + 20;
    if Ny-col_ind(end) < 10
        col_ind(length(col_ind)+(Ny-col_ind(end)+1):length(col_ind))=[];        
    end
end
dashed = [dashed, col_ind];
seq_dash(50,dashed,:) = 1;

%% Generate plot with zf result
if iteration_DLTG==1
    PSNR_zf = ones(maxIt_DLTG+1)*PSNR(seq,seq_zf);
    figure(100);
    subplot(221);imshow(seq_dash(:,:,1));title('Original sequence');
    subplot(224);plot(0:maxIt_DLTG,PSNR_zf,'--k'); grid on;
    title('PSNR performance');
    xlabel('Iterations');
    ylabel('PSNR (dB)');
    legend('Z-F','DLTG');
    drawnow;    
end

figure(100);
subplot(222);imshow(abs(seq(:,:,1)-seq_zf(:,:,1))*2);title('Error \times 2');
subplot(223);imshow(seq_dltg(:,:,1));title('DLTG reconstruction');
subplot(224);hold on;plot(0:iteration_DLTG,PSNR_dltg,'-b.');
drawnow;

%% Generate plot with temporal profile comparison
profile_im1 = zeros(size(seq,3),size(seq,2));
profile_im2 = zeros(size(seq_dltg,3),size(seq,2));

for t = 1:size(seq,3)
    profile_im1(t,:) = seq(Nx/2,:,t);
    profile_im2(t,:) = seq_dltg(Nx/2,:,t);
end

figure(101);
subplot(3,1,1);imshow(profile_im1); title('Original profile');
subplot(3,1,2);imshow(profile_im2); title('DLTG profile');
subplot(3,1,3);imshow(abs(profile_im1-profile_im2)*5); title('Error profile \times 5');
drawnow;

end