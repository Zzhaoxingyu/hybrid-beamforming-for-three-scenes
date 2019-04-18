function [W_RF,W_BB]=OMP_Combining(F_RF,F_BB)
global  Nr Ns Nrf H Vn Codebook_w
W_RF = [];
W_MMSE = ((F_BB' * F_RF' * H' * H * F_RF * F_BB + Vn * Ns * eye(Ns))^(-1) * F_BB' * F_RF' * H')';
Wres = W_MMSE;
n = 1 / Ns * H * F_RF * F_BB * F_BB' * F_RF' *H' + Vn * eye(Nr);
for i = 1 : Nrf    
    y = Codebook_w' * n * Wres;
    k = find(diag(y * y')==max(diag(y * y')));
    W_RF(:,i) = Codebook_w(:,k);
    W_BB = (W_RF' * n * W_RF)^(-1) * W_RF' * n * W_MMSE;
    Wres = (W_MMSE - W_RF * W_BB) / norm(W_MMSE - W_RF * W_BB,'fro');
end
