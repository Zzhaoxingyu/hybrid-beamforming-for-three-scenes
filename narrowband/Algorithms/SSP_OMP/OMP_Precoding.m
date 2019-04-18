function [F_RF,F_BB]=OMP_Precoding()
global Ns Nt Nrf H Codebook_v
F_RF = [];
[~,~,V] = svd(H);
F_opt = V(:,1:Ns);
Fres = F_opt;
for i = 1:Nrf
    y = Codebook_v'*Fres;
    k = find(diag(y*y')==max(diag(y*y')));
    F_RF (:,i) = Codebook_v(:,k);
    F_BB = (F_RF' * F_RF)^(-1) * F_RF' *F_opt;
    Fres = (F_opt - F_RF * F_BB)/norm(F_opt - F_RF * F_BB,'fro');
end
F_BB = sqrt(Ns) * F_BB / norm(F_RF * F_BB,'fro');