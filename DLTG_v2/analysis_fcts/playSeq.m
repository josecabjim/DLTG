function playSeq(seq)
% playSeq(seq)
%
% Load a sequence of images and play it as a video. To stop use force stop
% ctrl+c (or ctrl+.).
%
% INPUTS
%   seq...         A 3D matrix containing a sequence of 2D xy images.

%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  May 2014

figure(1);

while(1)
for n = 0:size(seq,3)-1
    
    imshow(seq(:,:,n+1),'InitialMagnification', 300);
    pause(0.05);
    
end
end
    
end