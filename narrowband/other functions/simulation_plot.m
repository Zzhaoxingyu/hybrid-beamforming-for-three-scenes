function [Sim_Rate, Sim_Mse, Sim_Ber] = simulation_plot(Data, vec, Algorithms)
% function for plotting figures
% Data is a cell containing all the results
% vec is the x axis vector

[row,col] = size(Data);

for i = 1 : row
    for j = 1 : col
        data_one = Data{i,j};
        Sim_Rate(i,j) = data_one.Rate;
        Sim_Mse(i,j) = data_one.Mse;
        Sim_Ber(i,j) = data_one.Ber;
    end
end

plot_Rate;
plot_Mse;
plot_Ber;

    function plot_Rate
        figure;
        for m = 1: col
            plot(vec,Sim_Rate(:,m),'LineWidth',2);
            hold on
        end
        title('Rate');
        ylabel('Rate(bits/s/Hz');
        legend(Algorithms);
    end

    function plot_Mse
        figure;
        for m = 1: col
            semilogy(vec,Sim_Mse(:,m),'LineWidth',2);
            hold on
        end     
        title('MSE');
        ylabel('MSE Value');
        legend(Algorithms);
    end

function plot_Ber
        figure;
        for m = 1: col
            semilogy(vec,Sim_Ber(:,m),'LineWidth',2);
            hold on
        end     
        title('BER');
        ylabel('BER');
        legend(Algorithms);
    end
end
