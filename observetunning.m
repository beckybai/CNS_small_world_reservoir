%Preparing the data for function 'valid_points.m'
clear fire
num_neuron = size(rateList{1,1},1);
num_test = size(testingResult,1);

%num_test = size(testingResult,1);

fireatlast = zeros(1200,num_test);

for i = 1:num_test
    nowrate = rateList{i,1};
    for j = 1:10:940
        fire{(j-1)/10+1}(:,i) = nowrate(:,j);
    end
end
fireatlast = fireatlast';

stimulus = testingResult(:,1:2);
stimulus(:,3) = stimulus(:,1)>stimulus(:,2);
stimulus(:,4) = stimulus(:,1)- stimulus(:,2);
