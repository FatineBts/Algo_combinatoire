function [y,z]=lienstetra(N)
%liens tetraedre issus de Smith
y = zeros(N,N-2); 
z = zeros(N-2,N-2); 
y(1,1) = 1; 
y(2,1) = 1; 
y(3,2) = 1; 
y(4,2) = 1; 
z(1,2) = 1;

end