function f = lagrange_obj(X,P,N,D, pi )
%fonction objectif avec contrainte de degre 3

f=0;
s1=0;
s2=0;
%ind = saut(1) + p*D + q;
%fonction objectif
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

s = 0;

%contrainte relachee
for q =1:N-2
    s1 = 0;
    s2 = 0;
    s3 = 0;
    for p=1:N
      s1 = s1 +  X(index(2,p,q,N,D));
    end
    
    for p=1:N-2
      if p < q
          s2 = s2 + X(index(3,p,q,N,D));
      end
      if p > q
          s3 = s3 + X(index(3,q,p,N,D));
      end
    end
    
    s = s + (s1+ s2 + s3  )* pi(q);
end

f = f+ s;

end

