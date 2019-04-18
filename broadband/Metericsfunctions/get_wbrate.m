function [rate,A] = get_wbrate(V_equal,W_equal)
global Nk H;
rate = zeros(Nk,1);
for k = 1:Nk
    rate(k) = get_rate(V_equal(:,:,k),W_equal(:,:,k), H(:,:,k));
end

A = rate;
rate = sum(rate)/Nk;