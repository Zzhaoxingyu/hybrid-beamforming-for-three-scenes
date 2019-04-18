function [rate,A] = get_scrate(V_equal,W_equal)

global Nk H;
rate = zeros(1,Nk);
for k = 1:Nk
    rate(k) = get_rate(V_equal,W_equal(:,:,k),H(:,:,k));
end

A=rate;
rate = mean(rate);
