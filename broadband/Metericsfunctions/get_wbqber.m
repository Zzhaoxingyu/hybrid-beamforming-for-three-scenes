function qber = get_wbqber(obj, qbit)

global Ns Nk Nr Vn H hMod hDemod;

V_RF = quantizeRF(obj.V_RF,qbit);
W_RF = quantizeRF(obj.W_RF,qbit);

for k = 1:Nk
    V_equal(:,:,k) = V_RF * obj.V_B(:,:,k);
     V_equal(:,:,k) =  V_equal(:,:,k)/norm( V_equal(:,:,k),'fro');
    W_equal(:,:,k) = W_RF * obj.W_B(:,:,k);
end

data = randi([0 1],Nk*Ns*2,1);

s = reshape(step(hMod,data),Ns, Nk);

u = sqrt(Vn/2).*(randn(Nr,Nk)+1i*randn(Nr,Nk));

r = zeros(Ns,Nk);
for k = 1:Nk
    r(:,k) = W_equal(:,:,k)' * H(:,:,k) * V_equal(:,:,k) * s(:,k) + W_equal(:,:,k)' * u(:,k);
end

de_data = step(hDemod, r(:));
qber = biterr(data,de_data);
