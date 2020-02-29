function ProgressDLTG(iteration_DLTG,maxIt_DLTG)
% PROGRESSDLTG - AUXILIARY FUNCTION
%  Provide update on the progress of the DLTG algorithm.
%
%  Inputs:
%   iteration_DLTG : Current DLTG iteration.
%   maxIt_DLTG     : Stopping DLTG iteration.


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


completed_dltg = (iteration_DLTG/maxIt_DLTG - 1/maxIt_DLTG)*100;
fprintf(['\n\n','DLTG iteration: %i (%2.2f%% completed)\n'],...
iteration_DLTG,completed_dltg);
disp('-------------------------------');
    
end