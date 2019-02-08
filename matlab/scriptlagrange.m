close all

N = 5;% nb de points fixes
D=2; % dimension
P = rand(N,D); % points fixes
% creation du vecteur X :
%longueur coord S, liens Y, liens Z
L=(N-2)*D+N*(N-2)+(N-2)*(N-2);
X=zeros(1,L);

f = fobj(X,P,N,D);
%contraintes d'égalité 
Leq=N+ 2*(N-2);
Aeq =zeros(Leq,L);

%contrainte sum_q (ypq)=1 pour tout p
for p=1:N
    for q=1:N-2
        ind=index(2,p,q,N,D);
        Aeq(p,ind)=1;
    end
end
saut=N;

%contrainte sum(z_pq)=1 pour tt q
for q=1:N-2
    for p=1:N-2
        ind=index(3,p,q,N,D);
        Aeq(saut + q,ind)=1;
    end
end

% contraintes inégalité
Ain=zeros(N-2,L);
%contrainte sum(y_pq)<=2 pour tt q
saut=0;
for q=1:N-2
    for p=1:N-2
        ind=index(2,p,q,N,D);
        Aeq(saut + q,ind)=1;
    end
end
% membre de droite b
beq=ones(1,Leq);
bin(1:N-2)=2;

