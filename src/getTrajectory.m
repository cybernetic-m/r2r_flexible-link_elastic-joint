function y = getTrajectory(startD, endD, T)
disp("Computing Trajectory...") 
% If we consider n modes, we want to control 2n+1 derivative
% so we need a polynomial of degree 4n + 3
% So, if we consider 3 modes, we need a polynomial of degree 15
% It has 8 coefficients to be determined, in fact we want to control
% the boundaries of the function itself and of its first 7 derivatives

% % The equation to solve are
% 
% % Function bound:
% eq1 = ones(1, 8);
% 
% % First derivative bound
% eq2 = [15 14 13 12 11 10 9 8];
% 
% % So on
% eq3 = eq2 * diag([14 13 12 11 10 9 8 7]);
% 
% eq4 = eq3 * diag([13 12 11 10 9 8 7 6]);
% 
% eq5 = eq4 * diag([12 11 10 9 8 7 6 5]);
% 
% eq6 = eq5 * diag([11 10 9 8 7 6 5 4]);
% 
% eq7 = eq6 * diag([10 9 8 7 6 5 4 3]);
% 
% eq8 = eq7 * diag([9 8 7 6 5 4 3 2]);
% 
% A = [eq1; eq2; eq3; eq4; eq5; eq6; eq7; eq8];
% b = [1 0 0 0 0 0 0 0]';
% 
% coeffs = A \ b;

% Shrinker but maybe inaccurate for high N
%   see article appendix for details
N = 15;
S = NaN((N+1)/2);
D = zeros((N+1)/2);
b = zeros((N+1)/2, 1);
b(1,1) = 1;
for r = 0:(N-1)/2
    for c = 0:(N-1)/2
        S(r+1, c+1) = factorial(N-r-c)^-1;
    end
    D(r+1, r+1) = factorial(N-r);
end
coeffs =  (S * D) \ b;

syms x real
y = startD + (endD-startD) * (coeffs' * [(x/T)^15 (x/T)^14 (x/T)^13 (x/T)^12 (x/T)^11 (x/T)^10 (x/T)^9 (x/T)^8]');

% Plot the trajectory found
% figure
% grid on
% fplot(y, [0, 1])

% Plot its derivative
% y = diff(y, degree);

% figure
% grid on
% fplot(y, [0, 1])

end