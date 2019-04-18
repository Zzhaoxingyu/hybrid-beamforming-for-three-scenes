function mse = get_wbmse(V_equal,W_equal)

global Nk H;
mse = zeros(Nk,1);
for k = 1:Nk
    mse(k) = get_mse(V_equal(:,:,k),W_equal(:,:,k),H(:,:,k));
end
mse = sum(mse)/Nk;