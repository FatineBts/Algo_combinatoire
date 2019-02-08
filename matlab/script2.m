close all
fileID = fopen('cube.txt');
str = fread(fileID,[1,inf],'char');
str = char(str);
eval(str);

plot3(P(:,1),P(:,2),P(:,3),'o')
B =[
    2.1944    1.3111    0.9230
    3.2851    4.7116    2.5090
    0.0000    0.0000    1.0000
    0.0000    0.0000    1.0000
    1.0000    0.0000    0.0000
    0.0000    1.0000    0.0000]


%N = 5;% nb de points fixes
%D=2; % dimension
%P = rand(N,D); % points fixes
S = rand(N-2,D); % Nos points steiner initiaux
Y = zeros(N,N-2); % liens P et S
Z=zeros(N-2,N-2); %liens S et S
RP=zeros(N,N-2); %valeur y_pq * norm(S_q -P_p)
RS=zeros(N-2,N-2); %valeur y_pq * norm(S_q -S_p)
[M,vec_norm]=norme_max(P);% M norme max

% creation du vecteur X :
%longueur coord S, liens Y, liens Z, val RP + val RS
L=(N-2)*D+N*(N-2)+(N-2)*(N-2)+N*(N-2)+(N-2)*(N-2);
X=zeros(1,L);
    %coordonn�es points Steiners
X(1:(N-2)*D)=reshape(S',1,(N-2)*D);


%contraintes d'�galit� 
Leq=N+ 3*(N-2);
Aeq =zeros(Leq,L);
%contrainte sum_q (ypq)=1 pour tout p
for p=1:N
    for q=1:N-2
        ind=index(2,p,q,N,D);
        Aeq(p,ind)=1;
    end
end
saut=N;
%contrainte degre S =3
for q=1:N-2
    for p=1:N
        ind=index(2,p,q,N,D);
        Aeq(saut + q,ind)=1;
        if (p<q)
            ind=index(3,p,q,N,D);
            Aeq(saut + q,ind)=1;
        end
        if (p>q)
            ind=index(3,p,q,N,D);
            Aeq(saut + q,ind)=1;
        end
    end
end

%contrainte sum(z_pq)=1 pour tt q
saut=saut + N-2;
for q=1:N-2
    for p=1:N-2
        ind=index(3,p,q,N,D);
        Aeq(saut + q,ind)=1;
    end
end

%contrainte sum(y_pq)<=2 pour tt q
saut=saut+N-2;
for q=1:N-2
    for p=1:N-2
        ind=index(2,p,q,N,D);
        Aeq(saut + q,ind)=1;
    end
end

%contrainte d'inegalit�
% lineariser Xp-Xq


