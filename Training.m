function [newWeights, trainingResults,rateList,testingResult,test_resize] = Training(Input, WMC, init_weights_s, time_s, train_para,test_para,ttq)
trainingResults = [];
dt = time_s.dt;
tau = time_s.tau;
simutime_len = length(time_s.simuTime);

wo1 = init_weights_s.weight_WMC_DM1;
wo2 = init_weights_s.weight_WMC_DM2;

num_train = train_para(1);
delta = train_para(2);
eta = train_para(3);
min_stimulus = train_para(4);
max_stimulus = train_para(5);
noiseGain = train_para(6);
x_ini = train_para(7);
gain = train_para(8);
tc = train_para(9);
dt_tau = tc*dt/tau;

% set the training data
training_data_list = SetTrainingData(min_stimulus, max_stimulus, num_train);

for k = 1:num_train
    % get the stimulus
    input_F = zeros(1, simutime_len);
    gainF1 = training_data_list(k, 1) ;  % presentation of stimulus f1
    gainF2 = training_data_list(k, 2)  ; % presentation of stimulus f2
    input_F(1, time_s.t1:time_s.t1+time_s.sdur) = gainF1;
    input_F(1, time_s.t2:time_s.t2+time_s.sdur) = gainF2;
    
    % initial the network of WMC
    x0_WMC = x_ini*randn(WMC.numNeurons, 1);
    x_WMC = x0_WMC;
    r_WMC = activity2rate(x_WMC,1);
    % initial the CP network
    %     r_CP = zeros(CP.numNeurons, 1);
    %     y = zeros(CP.numNeurons, time_s.ddur);
    
    % learning process in a trial
    % time_s.simuTime(test_size);
    ti=0;
    for t = time_s.simuTime
        ti = ti + 1;
        % the responses of the WMC
        %         x_WMC = (1.0-dt_tau)*x_WMC + init_weights_s.weight_WMC_WMC*(r_WMC*dt_tau) +...
        %             init_weights_s.weight_Input_WMC*(input_F(ti)*dt_tau) + noiseGain*randn(WMC.numNeurons, 1).*dt_tau;
        %         r_WMC = activity2rate(x_WMC);
        
        tini=0;
        deltat=dt;
        if tini+ti*deltat < 0.5 % before s1
            s=0;
        elseif tini+ti*deltat < 1.0 % presentation of s1
            s=gainF1;
        elseif tini+ti*deltat < 4.0 % delay
            s=0;
        elseif tini+ti*deltat < 4.5 % presentation of s2; decision period 1
            s=gainF2;
        else % decision period 2
            s=0;
        end
        
        
        
        rhs = -x_WMC+init_weights_s.weight_WMC_WMC*r_WMC/gain+init_weights_s.weight_Input_WMC*s+noiseGain*randn(WMC.numNeurons,1);
        x_WMC = x_WMC+dt_tau * rhs;
        r_WMC=activity2rate(x_WMC,1);
        
        if ti == (time_s.td+time_s.ddur)
            v1 = wo1'*r_WMC;
            %v1 = activity2rate(v1);
            v2 = wo2'*r_WMC;
            %v2 = activity2rate(v2);
            
            pa = 1./(1+exp(delta*(v2-v1)));
            a = v1>v2;
            if (gainF1>gainF2)== a
                rw=1;
            elseif gainF1 < gainF2 == a
                rw=0;
            end
            
            if (gainF1 == gainF2)
                rw  = (rand(1,1)>0.5);
            end
            %	r_WMC
            if v1>v2
                change =  eta*(rw-pa)*r_WMC*v1 - 0.01*wo1;
                wo1 = wo1 + change*exp(-num_train*0.01);
                wo1(init_weights_s.weight_WMC_DM1==0)=0;
             
            elseif v1<v2
                change =  eta*(rw-1+pa)*r_WMC*v2 - 0.01*wo2;
                wo2 = wo2 + change*exp(-num_train*0.01);
                wo2(init_weights_s.weight_WMC_DM2==0)=0;
            end
            
            if gainF1>gainF2
                trainingResults = [trainingResults;gainF1, gainF2, v1,v2,pa, rw];
            else
                trainingResults = [trainingResults;gainF1, gainF2,v1,v2 ,pa, rw];
            end
        end
        
    end
    
    if(mod(k,5) ==0)
        fprintf('train trial #: %d\n',k);
    end
    
    if( k == num_train)
        % testing process
        newWeights.weight_WMC_WMC = init_weights_s.weight_WMC_WMC;
        newWeights.weight_Input_WMC = init_weights_s.weight_Input_WMC;
        newWeights.weight_WMC_DM1 = wo1;
        newWeights.weight_WMC_DM2 = wo2;
        [rateList, testingResult] = Testing(Input, WMC, newWeights, time_s, test_para);
        
        fprintf('train trial #: %d\n',k);
        rr = sum(testingResult(:,4)>0)/size(testingResult(:,4),1);
        test_resize = reshape(testingResult(:,4),10,10);
        for i = 1:10
            for j = 1:10
                fprintf('%.0f ',test_resize(i,j));
            end
            fprintf('\n');
        end
        fprintf('right rate #: %d\n',rr);        
        
        fprintf('%d\n',sum(r_WMC(:)>0.2)/size(r_WMC,1));
        fprintf('%d\n',sum(r_WMC(:)>0.5)/size(r_WMC,1));
        fprintf('%d\n',sum(r_WMC(:)>0.8)/size(r_WMC,1));
        fprintf('%d\n',sum(r_WMC(:)>0.95)/size(r_WMC,1));
    end
    fprintf('%3f %3f %f %f %.2f %d %d\n',gainF1, gainF2, v1,v2,pa,v1>v2,gainF1>gainF2);    
end
save strcat(weights,num2str(rr)) newWeights

end


function gainList_train = SetTrainingData(min_stimulus, max_stimulus, num_train)
rng('shuffle', 'twister');
train_stimulus_range = max_stimulus - min_stimulus;
train_unit = train_stimulus_range/(sqrt(num_train)-1);
gg = min_stimulus:train_unit:min_stimulus+(sqrt(num_train)-1)*train_unit;
g1 = repmat(gg,sqrt(num_train),1);
g1 = reshape(g1,num_train,1);
g2 = repmat(gg',sqrt(num_train),1);
index = randperm(num_train);
gainList_train = [g1,g2];
gainList_train = gainList_train(index,:)+0.01*randn(num_train,2);

%%antoher mathold:if you want a random one ...
%gainList1_train = min_stimulus + (max_stimulus-min_stimulus)*rand(num_train, 1);
%gainList2_train = min_stimulus + (max_stimulus-min_stimulus)*rand(num_train, 1);
%gainList_train = [gainList1_train, gainList2_train];

end
