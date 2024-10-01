%clear % DON'T CLEAR WORKSPACE INHERITED FROM SIMULINK
close all

% Get the evolution evaluated with Simulink
state = out.state;

% Extract its components
q1 = state(:, 1)';
deltas = state(:, 2:end)';

%% Video parameters
framePerSecond = 60;
desiredDuration = 4*T;
framesNeeded = desiredDuration * framePerSecond;
step = floor(length(deltas) / framesNeeded);

%% Create a video object
videoObj = VideoWriter('stroboscopic_view.avi');
open(videoObj);

% Create the canvas
figure;
axis tight manual;
grid on;
ax = gca;
ax.NextPlot = 'replaceChildren';
ax.XLim = [-0.1 0.8];
ax.YLim = [-0.1 0.8];

xlabel 'x'
ylabel 'y'

axis square

% Text with simulation parameters in LaTeX with cmr and cmmi fonts
% Decomment if you want parameters on the plot
%txt = {['$l = ', num2str(L), '\:[m]$'], ['$\rho = ', num2str(rho), '\:[Kg/m^3]$'], ...
    %['$EI = ', num2str(EI), '\:[N\:m^2]$'], ['$k = ', num2str(k), '\:[N/m]$'], ...
    %['$I_R = ', num2str(Ir), '\:[Kg\:m^2]$'], ['$I_H = ', num2str(Ih), '\:[Kg\:m^2]$'], ...
    %['$m_P = ', num2str(mp), '\:[Kg]$'], ['$I_P = 0 \:[Kg\:m^2]$']};
%text(-.7, -.2, txt, 'Interpreter', 'latex', 'FontSize', 16);

%for i = 1:length(deltas)-1
for i = 1:step:length(deltas)

    % Current beam configuration
    q1Now = q1(:, i);
    deltasNow = deltas(:, i);

    y = xNum * sin(q1Now) + deltasNow' * phiX * cos(q1Now);
    xToPlot = xNum * cos(q1Now) - deltasNow' * phiX * sin(q1Now);

    % Force circular drawing
    for j = 1:length(xToPlot)
        if xToPlot(j)^2 + y(j)^2 > L^2
            xToPlot = xToPlot(1, 1:j-1);
            y = y(1, 1:j-1);
            break
        end
    end
    
    hold on;
    plot(xToPlot, y, 'k');
    
    % Plot q1 on the graph.
    r = L/4; % magnitude (length) of arrow to plot
    u = r * cos(q1Now); % convert polar (theta,r) to cartesian
    v = r * sin(q1Now);
    quiver(0, 0, u, v, 'k');
    
    hold off;
    
    % Decomment if you want to plot the time as title 
    %title(sprintf('t = %.2fs', i * sampleTime));
    
    % Update the figure
    drawnow;
    
    % Get the current frame
    frame = getframe(gcf);
    
    % Add the frame to the video
    writeVideo(videoObj, frame);
    
    %hold off;
end

% Close the video file
close(videoObj);