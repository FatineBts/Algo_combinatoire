function [c,ceq] = mycon(X,N,D)
c = [];    % Compute nonlinear inequalities at x.   
% Compute nonlinear equalities at x
L=N*(N-2)+ (N-2)*(N-2);
ceq=zeros(L,1);
saut=(N-2)*D;

for i=1:L
    ceq(i)= X(saut+i)*(X(saut+i)-1);
end

end