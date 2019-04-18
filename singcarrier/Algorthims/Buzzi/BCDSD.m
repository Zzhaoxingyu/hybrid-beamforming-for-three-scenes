function [V_RF,V_D,d] = BCDSD(V,N_RF)

[Nt,Ns] = size(V);
V_RF = 1/sqrt(Nt)*exp( 1i*unifrnd(0,2*pi,Nt,N_RF) );
n = 1;
while(n<=10)
    V_D = (V_RF'*V_RF)^(-1)*V_RF'*V;
    phi = V*V_D'*(V_D*V_D')^(-1);
    V_RF = exp(1i*angle(phi));
    u = norm(V_RF*V_D,'fro');
    d(n) = norm(V-V_RF*V_D,'fro');
    n = n + 1;
end

V_D=V_D/u;