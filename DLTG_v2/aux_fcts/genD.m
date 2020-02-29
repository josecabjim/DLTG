function [D, Dt] = genD(Nx,Ny,Nt)
% [D, Dt] = genD(Nx,Ny,Nt)
% 
% Generate matrices D and Dt necessary for TG filtering. This function is
% slow, so please use as preprocessing and store matrices before
% reconstructions.
%
% INPUTS
%   [Nx, Ny, Nt]...         Image dimensions
%
% OUTPUTS
%   [D, Dt]...              Input matrices for denoiseTV

%  Jose Caballero
%  Department of Computing
%  Imperial College London
%  jose.caballero06@gmail.com
%
%  May 2014

D = sparse(Nx*Ny*Nt,Nx*Ny*Nt);
Dt = sparse(Nx*Ny*Nt,Nx*Ny*Nt);


for i = 0:Nx*Ny*(Nt-1)-1;
    i
index_neg = 1+i*(1+Nx*Ny*Nt);
index_pos = (Nx*Ny*(Nt)*Nx*Ny+1) + i*(1+Nx*Ny*(Nt));
index_pos_t = Nx*Ny+1 + i*(1+Nx*Ny*Nt);
D(index_neg) = int8(-1);
D(index_pos) = int8(1);
Dt(index_neg) = int8(-1);
Dt(index_pos_t) = int8(1);
end

for i = 0:Nx*Ny-1
    i
    index_pos2 = 1+Nx*Ny*(Nt-1)+i*(1+Nx*Ny*(Nt));
    index_pos_t2 = Nx*Ny*(Nt-1)*Nx*Ny*Nt+1 + i*(1+Nx*Ny*(Nt));
    index_neg2 = Nx*Ny*Nt*(Nx)*(Ny)*(Nt-1)+1+Nx*Ny*(Nt-1)+i*(1+Nx*Ny*(Nt));
    index_neg_t2 = Nx*Ny*(Nt-1) + Nx*Ny*(Nt-1)*Nx*Ny*Nt+1 + i*(1+Nx*Ny*(Nt));
    
    D(index_pos2) = int8(1);
    D(index_neg2) = int8(-1);
    Dt(index_pos_t2) = int8(1);  
    Dt(index_neg_t2) = int8(-1);
end


% D = sparse(1,Nx*Ny*Nt);
% 
% D(1,:) = [-1,zeros(1,Nx*Ny),1,zeros(1,Nx*Ny*(Nt-1)-2)];
% Dt(:,1) = D.';
% 
% for n = 2:Nx*Ny*Nt
%     n
%     D(n,:) = circshift(D(1,:),[0 n-1]);
%     Dt(:,n) = D(n,:).';
% end

end