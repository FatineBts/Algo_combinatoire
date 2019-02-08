function f = fobj(X,P,N,D) %S Y Z
%fonction objectif de base
f=0;
s1=0;
s2=0;
%ind = saut(1) + p*D + q;
for p=1:N
    for q=1:N-2
        x1=X((q-1)*D + 1 : (q-1)*D + D);
        s1= s1 + X(index(2,p,q,N,D))*norme_carree(x1,P(p,:));
        
        if p<q
            x1=X((q-1)*D + 1 : (q-1)*D + D);
            x2=X((p-1)*D + 1 : (p-1)*D + D);
            s2= s2 + X(index(3,p,q,N,D))*norme_carree(x1,x2);
        end
    end
end
f=s1+s2;
end