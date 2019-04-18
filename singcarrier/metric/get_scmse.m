function mse = get_scmse(V_equal,W_equal)

global Nk H;

mse =zeros(1,Nk);
for k=1:Nk
    mse(k) = get_mse(V_equal,W_equal(:,:,k),H(:,:,k));
end

mse = mean(mse);