function [N, omega, phi, phi_prime] = getMode(nx, nEI, nL, nIh, nmp, nIp, nIr, nrho, nk, numRoots)
    disp("Computing phi(x) and N...")

    syms b x real

    % Define ausiliary variables to simplify the notation
    R = b * nmp / nrho;
    S = - nk / (2 * nEI * b);    
    T = b^3 * nIp/nrho;  
    U = b^3 * nIh / (2 * nrho);
    V = U + S;
    
    % Matrix determinant, to be set to zero
    deter = 2*V *(1+R*T) + 2*R * sin(b * nL) * sinh(b*nL) + ...
        + (1 - 2*V*R - 2*V*T - R*T) * sin(b * nL) * cosh(b * nL) + ...
        - (1 - 2*V*R + 2*V*T - R*T) * cos(b * nL) * sinh(b * nL) + ...
        - 2 * (V*R*T - V - T) * cos(b * nL)*cosh(b*nL);

    eq = matlabFunction(deter);
    
    [~, lengthX] = size(nx);
    
    % Stuff to find roots of deter
    xs = linspace(0, 100, 1001);
    ys = eq(xs);
    scinter = find(diff(sign(ys)));

    % Result initialization
    beta = NaN(1,numRoots);
    omega = NaN(1, numRoots);
    N = NaN(1, numRoots);
    phi = NaN(numRoots, lengthX); 
    phi_prime = NaN(numRoots, lengthX); 

    % Loop over the modes
    for i = 1:numRoots
        % Getting the i-th root
        r = fzero(eq, xs(scinter(i+1) + [0 1]));
        
        %% i-th phi calculation

        % Ri and Vi are shrinked to avoid numeric overflow
        % The result will be rescaled at the end according to
        %   the orthogonality condition of the solutions
        Ri = 1e-5 * vpa(subs(R, r));
        Vi = 1e-5 * vpa(subs(V, r));
        
        numSigma = Ri * sinh(r * nL) + cosh(r*nL) + Vi *(sin(r*nL) - sinh(r*nL)) - Vi * Ri*(cos(r*nL) - cosh(r*nL));
        denSigma = Ri * sin(r * nL) -cos(r*nL) + Vi*(sin(r*nL) -sinh(r*nL)) + Vi*Ri*(cos(r*nL) -cosh(r*nL));
        sigma = - numSigma / denSigma;
        
        % phi hat before normalization
        tmpPhiHat = sigma *sin(r*nx) + Vi*(1+sigma)* (cos(r*nx) - cosh(r*nx)) + sinh(r*nx);
        
        symPhiHat = @(x) sigma *sin(r*x) + Vi*(1+sigma)* (cos(r*x) - cosh(r*x)) + sinh(r*x);
        dphiHat = @(x) diff(symPhiHat(x));
        
        % Closed form of the integral
        intPhiHat = 1 / r^2 * (sigma * (sin(r*nL)-r*nL*cos(r*nL)) + Vi * (sigma +1)*(cos(r*nL) + cosh(r*nL)+r*nL*(sin(r*nL)-sinh(r*nL))-2)+r*nL*cosh(r*nL)-sinh(r*nL));
        
        % Find phi linear coefficient Fi
        Fi = 1/nIr * (nIh * dphiHat(0) + nrho * intPhiHat + nmp * nL * symPhiHat(nL) + nIp * dphiHat(nL));
        
        % phi before normalization
        tmpPhi = tmpPhiHat + Fi * nx;
        symPhi = @(x) sigma *sin(r*x) + Vi*(1+sigma)* (cos(r*x) - cosh(r*x)) + sinh(r*x) + Fi * x;
        
        
        % Derivative of phi wrt space
        symPhi_prime = @(x) diff(symPhi(x));
        Phi_prime = matlabFunction(symPhi_prime(x));
        
        % Square phi
        sqPhi = matlabFunction(symPhi(x) .* symPhi(x));
        
        % Normalization accordingly to orthogonality conditions of the solutions
        toBeNorm = nrho * integral(sqPhi, 0, nL);
        Ci = 1 / sqrt(toBeNorm);
        
        % Get the value to return
        beta(i) = r;
        phi(i, :) = Ci * tmpPhi;
        omega(i) = sqrt(r^4 * nEI / nrho);
        phi_prime(i,:) = Ci * Phi_prime(nx);

        
        symPhi = @(x) Ci * (sigma *sin(r*x) + Vi*(1+sigma)* (cos(r*x) - cosh(r*x)) + sinh(r*x) + Fi * x);
        xPhi = matlabFunction(x .* symPhi(x));
        N(i) = nrho * integral(xPhi, 0, nL);
    end

    % Print some results
    fprintf("\nFirst %d roots:", numRoots)
    disp(beta)
    fprintf("Corresponding pulses:")
    disp(omega)
    fprintf("Corresponding frequencies:")
    disp(omega / (2 * pi))
    fprintf("N coefficients:")
    disp(N)

end

