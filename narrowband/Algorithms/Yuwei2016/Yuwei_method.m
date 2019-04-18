function obj = Yuwei_method(obj)
% Hybrid digital and analog beamforming design for large-scale antenna arrays
global Ns Vn H ;

t1 = clock;
V_RF = yuweiA1();
Q = (V_RF'*V_RF);
T = Q^(-0.5);
L = H*V_RF*T;
[~,D,V] = svd(L);
[~,IX] = sort(diag(D),'descend');
M = V(:,IX);
U = M(:,1:Ns);
V_D = T*U;
V_D = V_D/norm(V_RF*V_D,'fro');

W_RF  = yuweiA2(V_D,V_RF);
J = W_RF'*H*V_RF*V_D*(V_D')*V_RF'*H'*W_RF+Vn*(W_RF')*W_RF;
W_D = J^(-1)*W_RF'*H*V_RF*V_D;


V = V_RF * V_D;
W = W_RF * W_D;

t2 = clock;
runtime = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_D;
obj.W_B = W_D;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj = get_metric(obj);
