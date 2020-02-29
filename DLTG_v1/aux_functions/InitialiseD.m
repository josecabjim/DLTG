function initdict = InitialiseD(params)
% INITIALISED - AUXILIARY FUNCTION
%  Initialise dictionary D with an overcomplete DCT dictionary.
%
%  Inputs:
%   params : Struct containing parameters for the K-SVD dictionary training
%            algorithm.
%     blocksize : 1x3 vector specifying the dimensions for the 3D patches
%                 used in the training and coding dictionary.
%     dictsize  : Integer defining the number of dictionary atoms.
%
%  Outputs:
%   initdict : Dictionary initialised with an overcomplete dictionary.
%
% *IMPORTANT*
%  This function requires the use of functions odctdict.m and initdict.m,
%  which can be found in
%  
%  ksvdbox13 (http://www.cs.technion.ac.il/~ronrubin/software.html)
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

initdict = odctndict(params.blocksize,params.dictsize,3);

initdict = initdict(:,1:params.dictsize);

end