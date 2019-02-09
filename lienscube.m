function [y,z]=lienscube(N)
%liens cube issus de Smith
y = zeros(N,N-2); 
z = zeros(N-2,N-2); 
y(1,11-N)=1;
y(2,10-N)=1;
y(3,11-N)=1;
y(4,10-N)=1;
y(5,12-N)=1;
y(6,12-N)=1;
y(7,13-N)=1;
y(8,14-N)=1;
z(1,2)=1;
z(1,3)=1;
z(3,5)=1;
z(4,6)=1;
z(5,6)=1;


end