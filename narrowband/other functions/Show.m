function obj = Show(obj)
global Nk N_loop Ns;

obj.Rate =  real(sum(obj.rate)/N_loop);

obj.Mse = real(sum(obj.mse)/N_loop);

obj.Ber = sum(obj.ber)/(2*N_loop*Ns);

disp(['Name: ', obj.Name]);

if obj.Rate
    disp(['Rate: ', num2str(obj.Rate)]);
end

if obj.Mse
    disp(['Mse: ',num2str(obj.Mse)]);
end

if obj.Ber
    disp(['Ber: ',num2str(obj.Ber)]);
end

disp(['Total Time: ' num2str(obj.runtime)]);

disp(' ');