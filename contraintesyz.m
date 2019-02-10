function [A,b,Aeq,beq]=contraintesyz(N,D)
Leq=N+ 2*(N-2); %pour les contraintes d'égalité 

COL=N*(N-2) + (N-2)*(N-2); %nb variables

Aeq=zeros(Leq,COL);
col=N-2;
for p=1:N %1ere contrainte
    for q=1:N-2
        Aeq(p,(p-1)*col +q)=1;
    end   
end
ind=N*(N-2);
saut=N;

 for q=1:N-2 %seconde contrainte
     for p=1:N
         Aeq(saut+q,(p-1)*col+q)=1;
     end
 end
 saut3=saut+ N-2;
  for q=1:N-2 %seconde contrainte
     for p=1:N-2
        Aeq(saut3+q, ind+ (p-1)*col+q)=1; %troisieme contrainte
         if (p<q)
             Aeq(saut+q, ind +(p-1)*col+q)=1;
         end
         if (p>q)
             ind=N*(N-2);
             Aeq(saut+q, ind +(q-1)*col+p)=1;
         end     
     end
  end

 if(D>=3) %contrainte d'inégalité  : 2 ne marche que pour la dimension >= 3
     L=N-2; 
     A=zeros(L,COL); %matrice de contraintes
     b=2*ones(L,1); %second membre
     for q=1:N-2 
         for p=1:N-2
             A(q,ind+(p-1)*col+q)=1;
         end
     end
 else
     A=[];
     b=[];
 end

 beq=ones(Leq,1);
 beq(N+1:N+N-2)=3;
end
