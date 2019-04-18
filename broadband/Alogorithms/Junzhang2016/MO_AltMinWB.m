function [ FRF,FBB ] = MO_AltMinWB( Fopt)

global Nrf;
[Nt, Ns, K] = size(Fopt);
y = [];
FRF = exp( 1i*unifrnd(0,2*pi,Nt,Nrf) );
while(isempty(y) || abs(y(1)-y(2))>1e-2)
    y = [0,0];
    for k = 1:K      
        FBB(:,:,k) = pinv(FRF) * Fopt(:,:,k); 
        y(1) = y(1) + norm(Fopt(:,:,k) - FRF * FBB(:,:,k),'fro')^2;
    end
    [FRF, y(2)] = sig_manifWB(Fopt, FRF, FBB);
end

end