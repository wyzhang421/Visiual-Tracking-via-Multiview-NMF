function NMF

clear all;
close all;
clc;

X=double(imread('lena.bmp'));
imshow(mat2gray(X));

X = double(X(:,:,1))/256;


[n m]=size(X);                                    %����X�Ĺ��
r = (n*m)/(m+n)                                  %���÷ֽ�������
U=rand(n,r);                            %��ʼ��UV��Ϊ�Ǹ���
V=rand(r,m);
maviter=r;                                    %����������
for iter=1:maviter
    U = U.*((X./(U*V))*V');
    U = U./(ones(n,1)*sum(U));    
    V = V.*(U'*(X./(U*V)));
end
whos U V

img_V=U*V;
figure;
imshow(mat2gray(img_V));