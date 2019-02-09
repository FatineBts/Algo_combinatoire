function script

N=4;
D=3;
X = rand(N-2,D); %points steiner
P = rand(N,D); %terminaux
[A,b,Aeq,beq]=contraintesyz(N,D);

%[A,b,Aeq,beq]=contraintesX(N,D);

fobjyz=@(YZ)objectiveyz(YZ,X,P,N,D);
fobjX=@(X)objectiveyz(YZ,X,P,N,D);

%Benders
%Initialisation
y = zeros(N,N-2); 
z = zeros(N-2,N); 

y(1,1) = 1; 
y(2,1) = 1; 
y(3,2) = 1; 
y(4,2) = 1; 
z(1,2) = 1; 

y = reshape(y.',1,[]);
z = reshape(z.',1,[]);
X=reshape(X.',1,[]);
YZ = [y,z]; 

%Sous-problème
[X,YZ,Longueur] = benders(X,YZ,P,N,D,A,b,Aeq,beq)
end 