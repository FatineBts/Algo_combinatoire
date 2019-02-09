function [A,b,Aeq,beq]=contraintesyz(N,D)
Leq=N+ 2*(N-2); %pour les contraintes d'égalité 
L=N-2; %inégalité
COL=N*(N-2) + (N-2)*(N-2); %nb variables

A=zeros(L,COL); %matrice de contraintes
Aeq=zeros(Leq,COL);
col=N-2;
for p=1:N %1ere contrainte
    for q=1:N-2
        Aeq(p,p*col +q)=1;
    end   
end
ind=N*(N-2);
saut=N;
 for q=1:N-2 %seconde et troisième contraintes
     for p=1:N
         Aeq(saut+q,p*col+q)=1;
         A(q,ind+p*col+q)=1;
         if (p<q)
             Aeq(saut+q, ind +p*col+q)=1;
         end
         if (p>q)
             ind=N*(N-2);
             Aeq(saut+q, ind +q*col+p)=1;
         end     
     end
 end
 saut= N+ N-2;
 for q=1:N-2 %contrainte d'inégalité  : 2 ne marche que pour la dimension >= 3
     for p=1:N-2
         Aeq(saut+q, ind+ p*col+q)=1;
     end
 end
 b=2*ones(L,1); %second membre
 beq=ones(Leq,1);
 beq(N+1:N+N-2)=3;
end
