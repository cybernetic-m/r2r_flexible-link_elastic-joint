% Clear any existing figures and close videos
close all

% Torque data
time = linspace(0, T, 501);
xToPlot = time;        % Time data
yToPlot_tau = transpose(out.torque)
% Data from Simulink of yd, theta and alphap
yToPlot_yd = transpose(out.angles(:,2))      
yToPlot_theta = transpose(out.angles(:,3))      
%yToPlot_alphap = transpose(out.angles(:,1))   % Decomment to plot alpha_p
yToPlot_tipdis = transpose(out.tip_dis)


%% Video parameters
framePerSecond = 60;
desiredDuration = 4*T; % 2*T; 
framesNeeded = desiredDuration * framePerSecond;
step = floor(length(xToPlot) / framesNeeded);

%% Create a video object
videoObj = VideoWriter('tau_angles_tipdis.avi');
open(videoObj);

% Create the canvas
figure;

% First subplot (Top figure with one signal)
subplot(3, 1, 1); % Divides the figure into 2 rows, 1 column, and selects the 1st subplot
axis tight manual;
grid on;
ax1 = gca;
ax1.NextPlot = 'replaceChildren';
ax1.XLim = [0 max(xToPlot)];
ax1.YLim = [double(min(yToPlot_tau))*1.1 double(max(yToPlot_tau))*1.1];
xlabel 'time [s]'
ylabel 'torque [Nm]'

% Second subplot (yd, theta. alphap)
% (Decomment if you want to plot alphap)
%subplot(3, 1, 2); % Select the 2nd subplot
%axis tight manual;
%grid on;
%ax2 = gca;
%ax2.NextPlot = 'replaceChildren';
%ax2.XLim = [0 max(xToPlot)];
%ax2.YLim = [min([yToPlot_yd, yToPlot_theta, yToPlot_alphap])*1.1, max([yToPlot_yd, yToPlot_theta, yToPlot_alphap])*1.1];
%xlabel 'time [s]'
%ylabel '[rad]' % Label for the second plot

% Second subplot (yd, theta)
subplot(3, 1, 2); % Select the 2nd subplot
axis tight manual;
grid on;
ax2 = gca;
ax2.NextPlot = 'replaceChildren';
ax2.XLim = [0 max(xToPlot)];
ax2.YLim = [min([yToPlot_yd, yToPlot_theta])*1.1, max([yToPlot_yd, yToPlot_theta])*1.1];
xlabel 'time [s]'
ylabel '[rad]' % Label for the second plot

% First subplot (Top figure with one signal)
subplot(3, 1, 3); % Divides the figure into 2 rows, 1 column, and selects the 1st subplot
axis tight manual;
grid on;
ax1 = gca;
ax1.NextPlot = 'replaceChildren';
ax1.XLim = [0 max(xToPlot)];
ax1.YLim = [double(min(yToPlot_tipdis))*1.1 double(max(yToPlot_tipdis))*1.1];
xlabel 'time [s]'
ylabel 'tip displacement[m]'


% Loop through the data and update the plots
for i = 1:step:length(xToPlot)

    % Current values for top plot
    currentX = xToPlot(1:i);
    currentY_tau = yToPlot_tau(1:i);
    
    % Current values for all three signals in bottom plot
    currentY_yd = yToPlot_yd(1:i);
    currentY_theta = yToPlot_theta(1:i);
    %currentY_alphap = yToPlot_alphap(1:i); % Decomment if you want also alpha_p

    % Current values for all three signals in bottom plot
    currentY_tipdis = yToPlot_tipdis(1:i);

    % Plot in the first subplot (tau)
    subplot(3, 1, 1);
    plot(currentX, currentY_tau, 'k');
    title(sprintf('t = %.2fs', max(currentX)));
    
    % Plot all three signals in the second subplot (variables yd, theta and alpha_p) 
    %(Decomment if you want to use alpha_p)
    %subplot(3, 1, 2);
    %plot(currentX, currentY_yd, 'k', currentX, currentY_theta, 'b', currentX, currentY_alphap, 'r');
    %legend({'$y_d$', '$\theta$', '$\alpha_P$'}, 'Interpreter', 'latex', 'Location', 'northwest');    
    %title(sprintf('t = %.2fs', max(currentX)));

    % Plot all three signals in the second subplot (variables yd, theta)
    subplot(3, 1, 2);
    plot(currentX, currentY_yd, 'k', currentX, currentY_theta, 'r');
    legend({'$y_d$', '$\theta$'}, 'Interpreter', 'latex', 'Location', 'northwest');    
    title(sprintf('t = %.2fs', max(currentX)));

    % Plot in the first subplot (tip displacement)
    subplot(3, 1, 3);
    plot(currentX, currentY_tipdis, 'k');
    title(sprintf('t = %.2fs', max(currentX)));

    % Update the figures
    drawnow;

    % Get the current frame for the video
    frame = getframe(gcf);

    % Add the frame to the video
    writeVideo(videoObj, frame);
end

% Drawing the last frame of tau plot
subplot(3, 1, 1);
plot(xToPlot, yToPlot_tau, 'k');
title(sprintf('t = %.2fs', T));

% Drawing the last frame of yd, theta, alphap plot 
% (Decomment if you want to use alphap)
%subplot(3, 1, 2);
%plot(xToPlot, yToPlot_yd, 'k', xToPlot, yToPlot_theta, 'b', xToPlot, yToPlot_alphap, 'r');
%legend({'$y_d$', '$\theta$', '$\alpha_P$'}, 'Interpreter', 'latex', 'Location', 'northwest');
%title(sprintf('t = %.2fs', T));

% Drawing the last frame of yd, theta plot 
subplot(3, 1, 2);
plot(xToPlot, yToPlot_yd, 'k', xToPlot, yToPlot_theta, 'r');
legend({'$y_d$', '$\theta$'}, 'Interpreter', 'latex', 'Location', 'northwest');
title(sprintf('t = %.2fs', T));

% Drawing the last frame of tip displacement plot
subplot(3, 1, 3);
plot(xToPlot, yToPlot_tipdis, 'k');
title(sprintf('t = %.2fs', T));

% Update the last frame
drawnow;
frame = getframe(gcf);
writeVideo(videoObj, frame);

% Close the video file
close(videoObj);