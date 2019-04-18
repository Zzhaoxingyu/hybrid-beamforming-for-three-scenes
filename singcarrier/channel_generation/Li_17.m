function [Ht, Hf] = Li_17(N_t, N_r)
global Nk
%fundemental parameters
Nc = 4; %cluster and ray
Nr = 10;

e_DS = 0.488;
e_ASD = 0.203;
e_ASA = 0.314;
m_DS = -7.893;
m_ASD = 0.675;
m_ASA = 1.304;
s_AODc = 4.23;
s_AOAc = 8.84;
r_DS = 1.309;
ThetaBs = 360*(rand(1)-0.5);
ThetaMs = 360*(rand(1)-0.5);
T= sqrtm([1 0.2891 0.0070 0.2389
    0.2891  1  0.6549  0.8273
    0.0070  0.6549  1   0.5678
    0.2389  0.8273  0.5678 1]);

x = T*randn(Nc,1);
s_DS = 10^(e_DS*x(1)+m_DS);
s_ASD = 10^(e_ASD*x(3)+m_ASD);
s_ASA = 10^(e_ASA*x(4)+m_ASA);
C = unifrnd(0,1,Nc,1);
%Cluster delay
for i = 1:Nc
    a(i) = -r_DS*s_DS*log(C(i));
end
a = sort(a);
for i = 1:Nc
    t(i) = a(i)-a(1);
end
%Path Power and alpha
for i = 1:Nc
    x = 10^0.446*randn(1);
    P(i) = exp(-t(i)*(r_DS-1)/(r_DS*s_DS))*10^(-x/10);
end
pzong  = sum(P);
P = P/pzong;
for i = 1:Nc
    for k = 1:Nr
        a = complex(randn(1),randn(1));
        a = a/norm(a);
        alpha(i,k) = a/norm(a)*sqrt(P(i)/Nr);
    end
end
%AOA and AOD
%t
K_ASD = 1.582;
K_ASA = 1.828;
Pmax = max(P);
aod_deg     = [0.0318 0.2034 0.4463 0.8951 1.9894 ];     % [1, Table 3]
delta_nm_aod = [aod_deg; -aod_deg];
beta_m = delta_nm_aod(:);
baoa(randperm(Nr)) = beta_m(1:Nr);
for i = 1:Nc
    U = sign(rand(1)-0.5);
    Vnt = s_ASD/7*randn(1);
    for k = 1:Nr
        thetat(i,k) = ThetaBs+U*K_ASD*s_ASD*log(P(i)/Pmax)+Vnt+s_AODc*beta_m(k);
    end
end

for i = 1:Nc
    U = sign(rand(1)-0.5);
    Vnr = s_ASA/7*randn(1);
    for k = 1:Nr
        thetar(i,k) = ThetaMs+U*K_ASA*s_ASA*log(P(i)/Pmax)+Vnr+s_AOAc*baoa(k);
    end
end

%time domain H
signature_t = [0:(N_t-1)]';
signature_t = 1i*pi* signature_t;                           %为接下来的signature构造做准备
signature_r = [0:(N_r-1)]';
signature_r = 1i*pi* signature_r;                           %为接下来的signature构造做准备
thetar = sin(thetar/180*pi);
thetat = sin(thetat/180*pi);
phi = 2*pi*rand(Nc,Nr);
for i = 1:Nc
    for m = 1:Nr
        h(:,:,i,m) = alpha(i,m)*exp((thetar(i,m)*signature_r))*exp((thetat(i,m)*signature_t))';  %omit the repeated 1/NtNr
     %  h(:,:,i,m)=complex(randn(1),randn(1))/sqrt(2)/Nr*exp((thetar(i,m)*signature_r))*exp((thetat(i,m)*signature_t))';
    end
end

Ht = sum(h,4);
%frequency domain H
for k = 1: Nk
    for i = 1: Nc
        hf(:,:,i) = Ht(:,:,i)*exp(-1i*2*t(i)*1e8*(k-1)/Nk);  
    end
    Hf(:,:,k) = sum(hf,3);       %每个子载波上的信道响应
end

    