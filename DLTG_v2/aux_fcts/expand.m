function out = expand(in, blocksize)
% out = expand(in, blocksize)
%
% Simulate edge wrap around in the image by expanding data on edges.
%
% INPUTS
%   in...                       Input image to expand
%   blocksize...                Size of expansion blocksize-1
%
% OUTPUTS
%   out...                      Expanded image

%  Jose Caballero
%  Department of Computing
%  Imperial College London
%  jose.caballero06@gmail.com
%
%  May 2014

if ismatrix(in)
    
    ext = blocksize-1;

    new_dim_r = size(in,1) + ext*2;
    new_dim_c = size(in,2) + ext*2;

    out(1:ext,1:ext) = in((end-ext+1):end,(end-ext+1):end);
    out(1:ext,(ext+1):(new_dim_c-ext)) = in((end-ext+1):end,:);
    out(1:ext,(ext+size(in,2)+1):new_dim_c) = in((end-ext+1):end,1:ext);
    out((ext+1):(new_dim_r-ext),1:ext) = in(:,(end-ext+1):end);
    out((ext+1):(new_dim_r-ext),(ext+1):(new_dim_c-ext)) = in;
    out((ext+1):(new_dim_r-ext),(ext+size(in,2)+1):new_dim_c) = in(:,1:ext);
    out((new_dim_r-ext+1):new_dim_r,1:ext) = in(1:ext,(end-ext+1):end);
    out((new_dim_r-ext+1):new_dim_r,(ext+1):(new_dim_c-ext)) = in(1:ext,:);
    out((new_dim_r-ext+1):new_dim_r,(new_dim_c-ext+1):new_dim_c) = in(1:ext,1:ext);
    
else
    
    ext = blocksize-1;
    
    % Old sequence dimensions
    old_dim_r = size(in,1);
    old_dim_c = size(in,2);
    old_dim_t = size(in,3);
    
    % New sequence dimensions
    new_dim_r = old_dim_r + ext*2;
    new_dim_c = old_dim_c + ext*2;
    new_dim_t = old_dim_t + ext*2;
    
    out = zeros(new_dim_r,new_dim_c,new_dim_t);
    
    
    out(1:ext,1:ext,1:ext) = in((end-ext+1):end,(end-ext+1):end,(end-ext+1):end);
    out(1:ext,(ext+1):(new_dim_c-ext),1:ext) = in((end-ext+1):end,:,(end-ext+1):end);
    out(1:ext,(new_dim_c-ext+1):new_dim_c,1:ext) = in((end-ext+1):end,1:ext,(end-ext+1):end);
    
    out(1:ext,1:ext,(ext+1):(new_dim_t-ext)) = in((end-ext+1):end,(end-ext+1):end,:);
    out(1:ext,(ext+1):(new_dim_c-ext),(ext+1):(new_dim_t-ext)) = in((end-ext+1):end,:,:);
    out(1:ext,(new_dim_c-ext+1):new_dim_c,(ext+1):(new_dim_t-ext)) = in((end-ext+1):end,1:ext,:);
    
    out(1:ext,1:ext,(new_dim_t-ext+1):new_dim_t) = in((end-ext+1):end,(end-ext+1):end,1:ext);
    out(1:ext,(ext+1):(new_dim_c-ext),(new_dim_t-ext+1):new_dim_t) = in((end-ext+1):end,:,1:ext);
    out(1:ext,(new_dim_c-ext+1):new_dim_c,(new_dim_t-ext+1):new_dim_t) = in((end-ext+1):end,1:ext,1:ext);
        
    
    out((ext+1):(new_dim_r-ext),1:ext,1:ext) = in(:,(end-ext+1):end,(end-ext+1):end);
    out((ext+1):(new_dim_r-ext),(ext+1):(new_dim_c-ext),1:ext) = in(:,:,(end-ext+1):end);
    out((ext+1):(new_dim_r-ext),(new_dim_c-ext+1):new_dim_c,1:ext) = in(:,1:ext,(end-ext+1):end);
    
    out((ext+1):(new_dim_r-ext),1:ext,(ext+1):(new_dim_t-ext)) = in(:,(end-ext+1):end,:);
    out((ext+1):(new_dim_r-ext),(ext+1):(new_dim_c-ext),(ext+1):(new_dim_t-ext)) = in(:,:,:);
    out((ext+1):(new_dim_r-ext),(new_dim_c-ext+1):new_dim_c,(ext+1):(new_dim_t-ext)) = in(:,1:ext,:);
    
    out((ext+1):(new_dim_r-ext),1:ext,(new_dim_t-ext+1):new_dim_t) = in(:,(end-ext+1):end,1:ext);
    out((ext+1):(new_dim_r-ext),(ext+1):(new_dim_c-ext),(new_dim_t-ext+1):new_dim_t) = in(:,:,1:ext);
    out((ext+1):(new_dim_r-ext),(new_dim_c-ext+1):new_dim_c,(new_dim_t-ext+1):new_dim_t) = in(:,1:ext,1:ext);
    
    
    out((new_dim_r-ext+1):new_dim_r,1:ext,1:ext) = in(1:ext,(end-ext+1):end,(end-ext+1):end);
    out((new_dim_r-ext+1):new_dim_r,(ext+1):(new_dim_c-ext),1:ext) = in(1:ext,:,(end-ext+1):end);
    out((new_dim_r-ext+1):new_dim_r,(new_dim_c-ext+1):new_dim_c,1:ext) = in(1:ext,1:ext,(end-ext+1):end);
    
    out((new_dim_r-ext+1):new_dim_r,1:ext,(ext+1):(new_dim_t-ext)) = in(1:ext,(end-ext+1):end,:);
    out((new_dim_r-ext+1):new_dim_r,(ext+1):(new_dim_c-ext),(ext+1):(new_dim_t-ext)) = in(1:ext,:,:);
    out((new_dim_r-ext+1):new_dim_r,(new_dim_c-ext+1):new_dim_c,(ext+1):(new_dim_t-ext)) = in(1:ext,1:ext,:);
    
    out((new_dim_r-ext+1):new_dim_r,1:ext,(new_dim_t-ext+1):new_dim_t) = in(1:ext,(end-ext+1):end,1:ext);
    out((new_dim_r-ext+1):new_dim_r,(ext+1):(new_dim_c-ext),(new_dim_t-ext+1):new_dim_t) = in(1:ext,:,1:ext);
    out((new_dim_r-ext+1):new_dim_r,(new_dim_c-ext+1):new_dim_c,(new_dim_t-ext+1):new_dim_t) = in(1:ext,1:ext,1:ext);
    
end

end