function [ U,v,VVT,YVT ] = conmf(y,U,v,VVT,YVT)
%   CONMF Summary of this function goes here
%   the sparsity penalty, weighted by a=1; 
%   the smoothness constraint, weighted by b=100; 
%   last term is a regularizer weighted by r=0.01;
%   the importance of new sample,weighted by k=10;


    a=1; b=100; r=0.01; k=10;
    maviter=10;
    I = eye(16,16);
    v1 = v;
    for iter=1:maviter
        v1 = v1.*((U'*y)+(b/k)*v)./((U'*U+(a/k)*ones(16,16)+(b/k)*I)*v1);
    end
    v = v1;
    %v = v.*((U'*y)+(b/k)*v)./((U'*U+(a/k)*ones(16,16)+(b/k)*I)*v);
    U = U.*((YVT+k*y*v')./(U*(VVT+k*v*v'+r*I)));
    VVT = VVT + v*v';
    YVT = YVT + y*v';


end

