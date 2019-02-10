function script
close all
%donnees P,N et D
fileID = fopen('cube.txt');
str = fread(fileID,[1,inf],'char');
str = char(str);
eval(str);

%matrices de contraintes
[A,b,Aeq,beq]=contraintesyz(N,D);

%Benders
%Initialisation
X = rand(N-2,D); %points steiner
%topo init cube (trouvee a la main avec hints)
[y,z]=lienscube(N); 

%topo init tetra (issu de Smith)
%[y,z]=lienstetra(N); 

%transformation vecteur pour X et liens y,z
y = reshape(y.',1,[]); 
z = reshape(z.',1,[]);
X = reshape(X.',1,[]);
YZ = [y,z]; 

%Benders
[k,X,YZ,Longueur] = benders2(X,YZ,P,N,D,A,b,Aeq,beq);
disp('Longueur')
disp(Longueur)
disp('Nb iterations')
disp(k)

%plot
X=reshape(X,[D,N-2])';
drawing(X,P,YZ,N)
end 