function tau = getTau(nIr, nIs, startD, endD, numN, omega, time, T)
disp("Computing tau...")
syms It N1 N2 N3 om1 om2 om3 real
syms c0 c1 c2 c3 real

% Define symbolic matrices of the Frame-on-Rotor case
C = [c0 c1 c2 c3];

M = [It N1 N2 N3; N1 1 0 0; N2 0 1 0; N3 0 0 1];
K = [0 0 0 0; 0 om1^2 0 0; 0 0 om2^2 0; 0 0 0 om3^2];
U = [1 0 0 0]';

B = M \ K;

% Get the general value of the c coefficients, according to
%   the solution of the equations found in y_coeff.m
% C = subs(C, c0, 1);
% 
% C = subs(C, c1, (1 - N2*c2 - N3*c3)/N1);
% 
% C = subs(C, c2, (om1^2 - N3*c3 *(om1^2 - om3^2))/(N2*(om1^2-om2^2)));
% 
% C = subs(C, c3, (om1^2 * om2^2) / (N3 * (om3^4 - om3^2*(om1^2 + om2^2) + om1^2*om2^2)));

A = [U'*inv(M)';
     U'*inv(M)'*K'*inv(M)';
     U'*inv(M)'*(K'*inv(M)')^2];

c_ns = null(A);
C = c_ns/c_ns(1);
C = transpose(C);

% Coefficient of tau in the (2n+2)-th derivative of y
tauCoeff = simplify(-C * B^3 * inv(M) * U);


% Coefficient of q in the (2n+2)-th derivative of y
qCoeffs = simplify(C * B^4);


% Build the transformation matrix Q 
Q = C;

for m = 1:3
    Q = [Q; (-1)^m *C*B^m];
end
Q = simplify(Q);



% Build the vector of y even derivative
yFunction = getTrajectory(startD, endD, T);
y = yFunction;

for m = 1: 3
    y = [y; diff(yFunction, 2*m)];
end


% Get the state by inverting the transformation
q = Q \ y;
q = q(2:end, :);


% Get the (2n+2)-th derivative of the desired trajectory
yDesired = diff(yFunction, 2*m+2);

% Evaluate tau from the (2n+2)-th derivative of y
tau = (yDesired - qCoeffs(:, 2:end) * q) / tauCoeff;


% Substitute numerical values
tau = subs(tau, It, nIr + nIs);
tau = subs(tau, [N1 N2 N3], numN);
tau = subs(tau, [om1 om2 om3], omega);


C = subs(C, [N1 N2 N3], numN);
C = subs(C, [om1 om2 om3], omega);


% Print c coefficients
disp("C =")
disp(vpa(C, 8))

syms x real
tau = subs(tau, x, time);

end