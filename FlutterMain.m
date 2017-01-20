close all;
clear;
tc = 1;
num_train = 169;
num_test = 100;
delta_const = 20;%a3: 20 a4:100
min_stimulus = 0.1;
max_stimulus = 1;
noiseGain = 0.01;
x_ini = 0.001;

%change the property of the reservoir  network
%reconnection probability
p_list = 0.1;
%number of simulation in order to avoid the repetation
num_simulations = 1:3;
%the gain
gain_factor_list = 1.2;
i_num = 0;

for s_iter = num_simulations
    for p_value = p_list
        for gain_factor = gain_factor_list
            i_num = i_num + 1;
            % initial the model
            [Input, WMC] = InitNetwork();
            
            % seting the connections of the model
            init_weights_s = SetConnection(Input, WMC,p_value);
            % init_weights_s = nnw;
            % seting the parameters of time shown in other part.
            time_s = SetTime();
            
            wmc = init_weights_s.weight_WMC_WMC;
            gain = (max(abs(eig(wmc))))/gain_factor;
            fprintf('the gain is %d\n', 1/gain );
            
            eta = 1/1000;   
            train_para = [num_train, delta_const, eta, min_stimulus, max_stimulus, noiseGain, x_ini,gain,tc];
            test_para = [num_test, delta_const, min_stimulus, max_stimulus, noiseGain, x_ini,gain,tc];
            
            % training process
            [newWeights, trainingResult,rateList,testingResult] = Training(Input, WMC, init_weights_s, time_s, train_para,test_para);
            
            train_para(8) = gain;
            train_para(3)= eta/10;                       
            p_rightrate = sum(testingResult(:,4)>0)/num_test;
            rightrate_list(i_num,1) = p_rightrate;
            
            % save path
            num_card_base = strcat('P_',num2str(p_value),'_',num2str(s_iter),'_',num2str(p_rightrate),'_',num2str(gain_factor),'_',num2str(tc));
            save_path = sprintf('rc_%s.mat',num_card_base);
            save_path_result = sprintf('rd_%s.mat',num_card_base);
            save(save_path,'testingResult','newWeights','fireatlast');
            save(save_path_result,'rightrate_list');
            close;
        end
    end
end
