N=5;
D=3;
X = rand(N-2,D); %points steiner
P = rand(N,D); %terminaux
[A,b,Aeq,beq]=contraintesyz(N,D);
%[A,b,Aeq,beq]=contraintesX(N,D);

fobjyz=@(YZ)objectiveyz(YZ,X,P,N,D);
fobjX=@(X)objectiveyz(YZ,X,P,N,D);