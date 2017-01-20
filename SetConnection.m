function init_weights_s = SetConnection(Input, WMC,p_value)
% weight initilization

% reservoir connection intiliazation
excited_num = WMC.numNeurons / 5 * 4;
inhibited_num = WMC.numNeurons - excited_num;
n = 960;
cp = 0.05; %connection probability
k =round(n*cp);
e_e = zeros(n,n);

for i = 1:n
    if i-k-1<0
        e_e(i,1:i+k) = lognrnd(0,1,[1,i+k]);
        left = abs(i-k-1);
        e_e(i,n-left+1:n)=lognrnd(0,1,[1,left]);
    elseif i+k >n
        e_e(i,i-k:n) = lognrnd(0,1,[1,n+k-i+1]);
        left = abs(k-(n-i));
        e_e(i,1:left) = lognrnd(0,1,[1,left]);
    else
        e_e(i,i-k:i+k) = lognrnd(0,1,[1,2*k+1]);
    end
    e_e(i,i)=0;
end
if p_value == 0
else
    for i = 1:n
        x = e_e(i,:);
        y = find(x);
        yr = randperm(2*k);
        e_e(i,y(1,yr(1,1:round((2*k)*p_value))))=0;
        yr2 = randperm(n);
        e_e(i,yr2(1,1:round((2*k)*p_value)))=lognrnd(0,1,[1,round((2*k)*p_value)]);
        e_e(i,i)=0;
    end
end

e_i = -abs((sprand_me(excited_num,inhibited_num,cp*4)));
i_e = abs((sprand_me(inhibited_num,excited_num,cp)));
i_i = -abs((sprand_me(inhibited_num,inhibited_num,cp*4)));
weight_WMC_WMC = [[e_e e_i];[i_e i_i]];

% the connections between input and WMC layers
weight_Input_WMC = (sprand_me(WMC.numNeurons, Input.numNeurons, 0.01));

% the connections between WMC and output
weight_WMC_DM1 =abs(sprand_me(WMC.numNeurons, Input.numNeurons, 0.5));
weight_WMC_DM2 = abs(sprand_me(WMC.numNeurons, Input.numNeurons, 0.5));
weight_WMC_DM1 = weight_WMC_DM1./norm(weight_WMC_DM1);
weight_WMC_DM2 = weight_WMC_DM2./norm(weight_WMC_DM2);

init_weights_s.weight_WMC_WMC = weight_WMC_WMC;
init_weights_s.weight_Input_WMC = weight_Input_WMC;
init_weights_s.weight_WMC_DM1 = weight_WMC_DM1;
init_weights_s.weight_WMC_DM2 = weight_WMC_DM2;
