function [Input, WMC] = InitNetwork()

Input.numNeurons = 1; 

% the WMC is a recurrent network with sparse connections
WMC.numNeurons = 1200; %1200 neurons in total
WMC.prob = 0.1; 
