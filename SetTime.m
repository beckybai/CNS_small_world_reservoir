function timeset = SetTime()

dt = 0.005;
t1 = 0.5;               % initial time before the first stimulus
sdur = 0.5;             % duration of two stimuli
ndelay = 3;             % delay between two stimuli
ddur = 0.7;             % duration of the decision
tau = 0.3;

n_t1 = ceil(t1/dt);
n_sdur = ceil(sdur/dt);
n_t2 = n_t1 + ceil(ndelay/dt) + n_sdur;
n_td = n_t2;
n_ddur = ceil(ddur/dt);

nsecs = t1+ndelay+sdur+ddur;
simutime = dt:dt:nsecs;

timeset.dt = dt;

timeset.tau = tau;
timeset.t1 = n_t1;
timeset.sdur = n_sdur;
timeset.t2 = n_t2;
timeset.td = n_td;
timeset.ddur = n_ddur;
timeset.simuTime = simutime;