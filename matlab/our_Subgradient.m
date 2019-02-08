function [ X, theta ] = our_Subgradient( P,N,D,eps, p, pi0, iterLimit, DualNoChangTOL, f, A, b, Aeq, beq, ub, lb,mycon,x0)
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
k = 1;
t = 1;
beta = - 1e23; % - infinity
pi = pi0;
J = length(pi0); % length for all components j in J

[X, theta] = fmincon(f,x0,A,b,Aeq,beq,lb,ub,[]);

% stopping criteria
while ( abs( lagrange_obj(X,P,N,D, pi) - theta)/theta > eps || k <= iterLimit )

    % solve lagrangian relaxation: theta(pi) = min L( x,pi)
    %theta = ...
    f = @(X) lagrange_obj(X,P,N,D, pi)
    % x = argmin ( L(x, pi) : x )
    %x = ...
    
    opts = optimset('Display','iter','Algorithm','interior-point', 'MaxFunEvals', 10000);
    [X,theta,exitflag,output] = fmincon(f,X,A,b,Aeq,beq,lb,ub,[],opts);
    
    theta
    y = [Aeq ; A]*X';
    
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
    
    if y <=eps*ones(size(y))
        disp('number of iterations');
        disp(k);
        k = iterLimit + 1; % stop algorithm
    else
       % theta_chap = applyMHeuristirc(x,f, X and F)
       %opts = optimoptions(@patternsearch,'AccelerateMesh',true,'ScaleMesh',false, 'PollMethod', 'GPSPositiveBasisNp1', 'TolBind',1000);
       [xx, theta_chap] = patternsearch(f,X,A,b,Aeq,beq,lb,ub,mycon);
       
       % for all entries of vector pi 
       for j = 1:J
           % take maximum of 0 and 
           pi(j) = max(0, pi(j) - y(j)*p*(theta - theta_chap)/norm(y) );
       end
       
       
       disp('number of iterations')
       disp(k)
       k = k + 1;
       
    end  
end

end
