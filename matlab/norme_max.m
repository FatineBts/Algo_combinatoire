function [M,vec_norm] = norme_max(X)
%renvoie la norme maximale entre les terminaux
n=length(X);
vec_norm=zeros(n,1);
for i=1:n-1
    for j=i+1:n
    vec_norm(i)=norm(X(i,:)-X(j,:));
    end
end
M=max(vec_norm);
end

