function PlaySeqError(seq1, seq2)
% PLAYSEQERROR - ANALYSIS FUNCTION
%  Load two sequences of images, play them and their amplified error as a
%  video.
%
%  Inputs:
%    [seq1, seq2] : A 3D matrix containing a sequence of 2D xy images.


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


figure(1);
subplot(131); title('Sequence 1');
subplot(132); title('Sequence 2');
subplot(133); title('Sequence (1-2) \times 5');
pause(0.05);

while(1)
for n = 0:size(seq1,3)-1
    
    figure(1);
    subplot(131);imshow(seq1(:,:,n+1)); 
    subplot(132);imshow(seq2(:,:,n+1));
    subplot(133);imshow(abs(seq1(:,:,n+1)-seq2(:,:,n+1))*5);
    pause(0.05);
    
end
end
    
end