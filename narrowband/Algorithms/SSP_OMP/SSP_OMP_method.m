function obj = SSP_OMP_method(obj)

t1 = clock;
[F_RF,F_BB] = OMP_Precoding();
[W_RF,W_BB] = OMP_Combining(F_RF,F_BB);
F = F_RF * F_BB;
W = W_RF * W_BB;

t2 = clock;
runtime = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = F_BB;
obj.W_B = W_BB;
obj.V_RF = F_RF;
obj.W_RF = W_RF;
obj = get_metric(obj);