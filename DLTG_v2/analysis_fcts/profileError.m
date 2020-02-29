function profileError(seq1,seq2,row)
% profileError(seq1,seq2,row)
%
% Load two sequences of images and display the same row in each as a
% temporal profile. Their aplified error is also amplified and displayed.
%
% INPUTS
%   seq...      A 3D matrix containing a sequence of 2D xy images.
%   row...      Row selected to display as a temporal profile. Has to be an
%               integer between 1 and size(seq,1).

%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  May 2014


figure(1)

profile_im1 = zeros(size(seq1,3),size(seq1,2));
profile_im2 = zeros(size(seq2,3),size(seq1,2));

for t = 1:size(seq1,3)
    profile_im1(t,:) = seq1(row,:,t);
    profile_im2(t,:) = seq2(row,:,t);
end

subplot(3,1,1);imshow(profile_im1); title('Profile 1');
subplot(3,1,2);imshow(profile_im2); title('Profile 2');
subplot(3,1,3);imshow(abs(profile_im1-profile_im2)*5); title('Profile (1-2) \times 5');

end