%% script_subgrad
close all
fileID = fopen('cube.txt');
str = fread(fileID,[1,inf],'char');
str = char(str);
eval(str);
plot3(P(:,1),P(:,2),P(:,3),'o')
hold on

%Matrice des contraintes
[ Aeq, beq, b , A ] = constraintes( N, D, P);

eps=0.01;
DualNoChangTOL=5;
pi0 = zeros(N-2,1);
p=0.5;
L=(N-2)*D+N*(N-2)+(N-2)*(N-2);
ub=ones(L,1)';
ub(1:(N-2)*D)=5;
lb = zeros(L,1)';


f_obj = @(X)(fobj(X,P,N,D));

% contraintes du type y*(y-1)=0 pour liens binaires 
con=@(X) mycon(X,N,D);

%coordonnees points Steiners
x0=rand(N-2,D);% coordonnees random entre 0 et 1 car terminaux entre 0 et 1
X0=zeros(1,L); %liens egaux a O 
X0(1:(N-2)*D)=reshape(x0',1,(N-2)*D);
X0((N-2)*D+1:end)=0;

%resolution
[ x, theta ] = our_Subgradient(P,N,D, eps, p, pi0, 100, DualNoChangTOL, f_obj,A, b, Aeq, beq, ub, lb,con,X0);


%plot points steiner trouves
B1=reshape(x(1:(N-2)*D),[D N-2])';
plot3(B1(:,1),B1(:,2),B1(:,3),'o')


