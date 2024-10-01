clear
close all 
clc

% Choose the number of roots (for now 3 is mandatory)
numRoots = 3;

% Symbolic quantities
syms It real

M = sym('M', [numRoots+1 numRoots+1], "real");
K = sym('K', [numRoots+1 numRoots+1], "real");

N = sym('N', [1 numRoots], "real");
om = sym('om', [1 numRoots], "real");

%% "M, K, U" MATRICIES DEFINITION
for r = 2:numRoots+1
    for c = 2:numRoots+1
        M(r,c) = r==c;
    end
end

M(:, 1) = [It N];
M(1, :) = [It N]';

for r = 1:numRoots+1
    for c = 1:numRoots+1
        if r==c && r>1
            K(r,c) = om(r-1)^2;
        else
            K(r,c) = 0;
        end
    end
end

U = zeros(numRoots+1, 1);
U(1,1) = 1;

%% ROBOT PARAMETERS
%EI = 2.4507;
EI = 0.6;
L = 0.7;    
%Ih = 1.95e-3;
Ih = 0;
Ip = 0;
Ir = 1;
mp = 2;
%mp = 0;
%rho = 2.975;
rho = 4;
k = 100;
dampFactor = 0;

%% TRAJECTORY PARAMETERS
T = 1; % secs
startD = 0; %Initial configuration
endD = pi/2; %Final Configuration

% Spatial interval
samplesX = 500;
xNum = linspace(0, L, samplesX);

% Solve the beam behaviour through mode analysis
[numN, omega, phiX, phiX_prime] = getMode(xNum, EI, L, Ih, mp, Ip, Ir, rho, k, numRoots);
phiL = phiX(:, end);
phiL_prime = phiX_prime(:,end);
numN
omega.^2

%% EVALUATION OF "M, K" MATRICIES
M = subs(M, It, Ir+Ih);
M = double(subs(M, N, numN));

K = double(subs(K, om, omega));

%% "A,B,C,D" LINEAR SYSTEM MATRICIES
damp = eye(numRoots+1) * dampFactor;
damp(1,1) = 0;

A = [zeros(numRoots+1), eye(numRoots+1);
     -M^-1*K,           -inv(M)*damp];

B = [zeros(numRoots+1,1); M^-1*U];

C = eye(numRoots*2+2);

D = zeros(numRoots*2+2, 1);

%Initial state x = [q1, delta1, delta2, delta3, q1_dot, delta1_dot, delta2_dot, delta3_dot]
x0 = [0 0 0 0 0 0 0 0]'; 

%% FEEDFORWARD TERM tau_d

time = linspace(0, T, 1000);
data_tau = getTau(Ir, Ih, startD, endD, numN, omega, time, T);

tau = timeseries(double(data_tau), time');
enableTau = 1;

%% TRAJECTORY PLANNING
syms x real

traj = getTrajectory(startD, endD, T);
traj = vpa(traj,3);
traj_dot = vpa(diff(traj,x),3);

traj = subs(traj, x, time);
q1d = timeseries(double(traj), time);

traj_dot = subs(traj_dot, x, time);
q1d_dot = timeseries(double(traj_dot), time);

%% PD REGULATION PART

% WITHOUT PD (ONLY FEEDFORWARD)
Kp = 0;
Kd = 0;

% Kp, Kd for long time motion but almost zero oscillation
% Kp = 30;
% Kd = 900;

% % Kp, Kd for short time motion with oscillation
% Kp = 150;
% Kd = 200;

%% SIMULATION DATA

% Use this for the simulation of only tau_feedforward
sampleTime = T/500; %secs

% Saturation value for the motor torque
tauLim = 100000;

disp("Ready for Simulink")