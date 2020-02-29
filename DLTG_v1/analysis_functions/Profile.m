function Profile(seq, row)
% PROFILE - ANALYSIS FUNCTION
%  Load a sequence of images, play it as a video and display one row as a
%  temporal profile.
%
%  Inputs:
%    seq : A 3D matrix containing a sequence of 2D xy images.
%    row : Row selected to display as a temporal profile. Has to be an
%         integer between 1 and size(seq,1).


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


[Nx,Ny,Nt] = size(seq);

figure(1)

profile_im = zeros(Ny,Nt);

for t = 1:Nt
    profile_im(:,t) = seq(row,:,t).';
end

figure(1);imshow(profile_im.');

subplot(122);imshow(profile_im);

% Draw dashed line on original sequence
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
seq(row,dashed,:) = 1;

while(1)
for n = 0:Nt-1
    
    figure(1);
    subplot(121);imshow(seq(:,:,n+1),'InitialMagnification', 300);
    pause(0.05);
    
end
end

end