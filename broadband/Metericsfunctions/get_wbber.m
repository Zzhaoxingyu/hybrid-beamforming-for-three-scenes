function [ber,suberror] = get_wbber(V_equal, W_equal)

global Ns Nk Nr Vn H hMod hDemod;

data = randi([0 1],Nk*Ns*2,1);

s = reshape(step(hMod,data),Ns, Nk);

u = sqrt(Vn/2).*(randn(Nr,Nk)+1i*randn(Nr,Nk));

r = zeros(Ns,Nk);
for k = 1:Nk
    r(:,k) = W_equal(:,:,k)' * H(:,:,k) * V_equal(:,:,k) * s(:,k) + W_equal(:,:,k)' * u(:,k);
end

de_data = step(hDemod, r(:));
ber = biterr(data,de_data);

for i = 1:Nk
    a = de_data(4*(i-1) + 1: (4*i));
    b = data(4*(i-1) + 1: (4*i));
    suberror(i) = biterr(a,b);
end


    
