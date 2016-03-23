function NMF

clear all;
close all;
clc;

X=double(imread('lena.bmp'));
imshow(mat2gray(X));

X = double(X(:,:,1))/256;


[n m]=size(X);                                    %计算X的规格
r = (n*m)/(m+n)                                  %设置分解矩阵的秩
U=rand(n,r);                            %初始化UV，为非负数
V=rand(r,m);
maviter=r;                                    %最大迭代次数
for iter=1:maviter
    U = U.*((X./(U*V))*V');
    U = U./(ones(n,1)*sum(U));    
    V = V.*(U'*(X./(U*V)));
end
whos U V

img_V=U*V;
figure;
imshow(mat2gray(img_V));