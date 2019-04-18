function obj = Mrate_wbmethod(obj)

global Nk V_ropt W_ropt;
t1 =clock();

for k = 1:Nk
    [V_ropt(:,:,k),W_ropt(:,:,k)] = Mrate_method(k);
end

t2 = clock;
runtime  = etime(t2,t1);
obj.V_B = V_ropt;
obj.W_B = W_ropt;
obj.runtime = obj.runtime + runtime;
obj = get_wbmetric(obj);