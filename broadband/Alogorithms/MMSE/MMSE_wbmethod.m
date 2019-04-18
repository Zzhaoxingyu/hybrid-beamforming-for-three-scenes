function obj = MMSE_wbmethod(obj)

%the algorithm for fully_digital design for WB case
%regard every sub_carrier problem as a narrowband case
%cite the paper Generalized linear precoder and decoder design for MIMO channels using the
%weighted mmse criterion
global Nk V_mopt W_mopt;
t1 =clock();
for k = 1:Nk
    [V_mopt(:,:,k),W_mopt(:,:,k)] = MMSE_method(k);
end

t2 = clock;
runtime  = etime(t2,t1);
obj.V_B = V_mopt;
obj.W_B = W_mopt;
obj.runtime = obj.runtime + runtime;
obj = get_wbmetric(obj);