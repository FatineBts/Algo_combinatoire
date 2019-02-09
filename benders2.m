function [k,X,YZ,Longueur]=benders2(X0,YZ0,P,N,D,A,b,Aeq,beq)

X = X0; 
A_z = [zeros(size(A,1),1),A];
b_z = b;
A_eqz = [zeros(size(Aeq,1),1),Aeq];
b_eqz = beq;
YZ = YZ0;

%initialisation
k = 1; 
LB = -Inf; 
UB = +Inf; 
K = []; 
k = 0; 
stop = false; 
COL = N*(N-2) + (N-2)*(N-2); 
while(stop==false && k < 1000)
    %Sous-probleme : on cherche x 
    fobjX=@(X)objectiveyz(YZ,X,P,N,D)
    X = patternsearch(fobjX,X,[],[]); 

    %On met a jour UB
    UB = min(UB,fobjX(X));
    
    % nouvelle contrainte
    ligne = zeros(1,1+COL);
    ligne(1) = -1; 
    
    cnt = 2; 
    for p = 1:N %pour les y
        for q = 1:(N-2)
            xq=X((q-1)*D+1:(q-1)*D+D);
            ligne(cnt) = norm(xq- P(p,:)); 
            cnt = cnt + 1; 
        end
    end 
   
    for p = 1:(N-2) %pour les z
        for q = 1:N-2
            if p<q
                xq=X((q-1)*D+1:(q-1)*D+D);
                xp=X((p-1)*D+1:(p-1)*D+D);
                ligne(cnt) = norm(xq-xp); 
            end
            cnt = cnt + 1; 
        end 
    end
    
    A_z = [A_z; ligne];
    b_z = [b_z; 0];
    
    %Sous-probleme : on cherche z
    fobjZ = zeros(COL+1,1);
    fobjZ(1) = 1;
    
    intcon = 2:COL+1; %elles sont toutes entières sauf la première
    lb = zeros(COL+1,1);
    ub = ones(COL+1,1);
    ub(1) = +Inf;
 
%     for p=1:N-2
%         for q=1:N-2
%             if(p<q)
%                 ub(N*(N-2)+p+q) = 1; 
%             end 
%         end 
%     end

    XZ = intlinprog(fobjZ,intcon,A_z,b_z,A_eqz,b_eqz, lb, ub); %on a Z puis YZ
    LB = XZ(1); 

    k = k + 1;

    if(LB >=UB) 
        stop = true;       
    else 
        YZ = XZ(2:end); 
    end
        
end

%Pour le plot
Longueur = UB;%XZ(1); 

end 
