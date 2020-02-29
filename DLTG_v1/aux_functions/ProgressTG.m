function ProgressTG(iteration_TG,maxIt_TG)
% PROGRESSTG - AUXILIARY FUNCTION
%  Provide update on the progress of the TG module.
%
%  Inputs:
%   iteration_TG : Current TG iteration.
%   maxIt_TG     : Stopping TG iteration.


%  Jose Caballero
%  Biomedical and Image Analysis Group
%  Department of Computing
%  Imperial College London, London SW7 2AZ, UK
%  jose.caballero06@imperial.ac.uk
%
%  October 2012


completed_tg = (iteration_TG/maxIt_TG)*100;
fprintf('...%i%%',completed_tg);

end