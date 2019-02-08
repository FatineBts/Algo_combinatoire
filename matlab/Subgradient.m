function [ x, theta ] = Subgradient( eps, p, pi0, iterLimit, DualNoChangTOL, f,coeff_f, A, b, ub, lb,m,n,integer_values,a,c,MM )
% eps : control parameter
% p in ]0,2[ : control parameter
% pi0 : initial nonnegative vector (usually the nul vector
% iterLimit : number of maximum iterations
% DualNoChangTOL : accepted number of iterations without change in the
%                  value of the dual function
% f : optimisation function
% theta : relaxation langrangienne
% g : constraints

% Ensure a local optimal of theta and an approximate primal solution x_chap
m
n
    
k = 1;
t = 1;
beta = - 1e23; % - infinity
pi = pi0;
J = length(pi0); % length for all components j in J

[x, theta] = linprog(coeff_f, A, b, [], [], lb, ub);
% stopping criteria
while ( abs( objective_lagrangian(x,a, c,MM, m ,n, pi ) - theta)/theta > eps || k <= iterLimit )

    % solve lagrangian relaxation: theta(pi) = min L( x,pi)
    %theta = ...
    f = @(X) objective_lagrangian(X,a, c,MM, m ,n, pi )
    % x = argmin ( L(x, pi) : x )
    %x = ...
    
    opts = optimset('Display','iter','Algorithm','interior-point', 'MaxFunEvals', 10000);
    [x,theta,exitflag,output] = fmincon(f,x,A,b,[],[],lb,ub,[],opts)
    
    y = A*x;
    
    % for all constraints y_j = g_j(x) 
    %y = A.*x - b; % y is a vector !!!
%     size(x)
%     size(A)
    
    
    if theta > beta
       beta = theta;
    else
        
        if t <= DualNoChangTOL
            t = t + 1;
        else
            p = p/2;
            t = 1;
        end
        
    end
    
    if y == zeros(size(y));
        disp('number of iterations');
        disp(k);
        k = iterLimit + 1; % stop algorithm
    else
       % theta_chap = applyMHeuristirc(x,f, X and F)
       [xx, theta_chap] = intlinprog(coeff_f,integer_values,A,b,[],[],lb,ub)
       
       % for all entries of vector pi 
       for j = 1:J
           % take maximum of 0 and 
           pi(j) = max(0, pi(j) - y(j)*p*(theta - theta_chap)/norm(y) );
       end
       
       k = k + 1;
       
    end
        
    
    
    
end

end
