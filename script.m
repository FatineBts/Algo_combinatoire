function script
close all
% fileID = fopen('cube.txt');
% str = fread(fileID,[1,inf],'char');
% str = char(str);
% eval(str);

% tetraedre
N=4;
D=3;
P = zeros(N,D); %terminaux
P = [0 0 0; 1 0 0; 0.5 0.86602540378 0.0; 0.5 0.28867513459 0.81649658092];


[A,b,Aeq,beq]=contraintesyz(N,D);
%Benders
%Initialisation
X = rand(N-2,D); %points steiner
%[y,z]=lienscube(N); %topo init cube
[y,z]=lienstetra(N); %topo init tetra



y = reshape(y.',1,[]); %vecteur
z = reshape(z.',1,[]);
X = reshape(X.',1,[]);
YZ = [y,z]; 

%Sous-problème
%[X,YZ,Longueur] = benders(X,YZ,P,N,D,A,b,Aeq,beq)
[k,X,YZ,Longueur] = benders2(X,YZ,P,N,D,A,b,Aeq,beq);
Longueur
disp('Nb iterations')
disp(k)
X=reshape(X,[D,N-2])';
%plot
drawing(X,P,YZ,N)
end 