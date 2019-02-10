function [k,X,YZ,Longueur]=benders2(X0,YZ0,P,N,D,A,b,Aeq,beq)

options = optimoptions('intlinprog','RootLPMaxIterations',3e6,'CutMaxIterations',40,'LPMaxIterations',3e6);
X = X0;
YZ = YZ0;
%Ajout variable z dans matrice contraintes sur les liens
A_z = [zeros(size(A,1),1),A];
b_z = b;
A_eqz = [zeros(size(Aeq,1),1),Aeq];
b_eqz = beq;


%initialisation
LB = -Inf; 
UB = +Inf;
k = 0; %iterateur
stop = false;
% nb variables pour y,z
COL = N*(N-2) + (N-2)*(N-2);

while(stop==false && k < 1000)
    %Sous-probleme : on cherche x pur y,z donne
    fobjX=@(X)objectiveyz(YZ,X,P,N,D)
    X = patternsearch(fobjX,X,[],[]); 

    %On met a jour UB
    UB = min(UB,fobjX(X));
    
    % nouvelle contrainte BENDERS cut -z + f(x_k,y,z) <=0 
    ligne = zeros(1,1+COL);
    ligne(1) = -1; %z
    
    cl=N-2;
    for p = 1:N %pour les y
        for q = 1:(N-2)
            xq=X((q-1)*D+1:(q-1)*D+D);
            ligne((p-1)*cl +1 + q) = norm(xq- P(p,:));
        end
    end 

    for p = 1:(N-2) %pour les z
        for q = 1:N-2
            if p<q
                xq=X((q-1)*D+1:(q-1)*D+D);
                xp=X((p-1)*D+1:(p-1)*D+D);
                ligne((p-1)*cl + 1+N*(N-2) + q) = norm(xq-xp); 
            end
        end 
    end
    
    %ajout a la matrice des contraintes
    A_z = [A_z; ligne];
    b_z = [b_z; 0];
    
    %on cherche y,z pour des x donne
    fobjZ = zeros(COL+1,1); % coeff de fobj
    fobjZ(1) = 1;
    
    intcon = 2:COL+1; %econtraintes d integrite 
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
    LB = XZ(1); %valeur de Z

    k = k + 1;

    if(LB >=UB) 
        stop = true; 
    else 
        YZ = XZ(2:end); % nouveau y,z
    end
        
end

%Pour le plot
Longueur =UB;% XZ(1); 

end 
