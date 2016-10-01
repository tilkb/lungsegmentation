function [ img ] = gauss_pixel( images,szigma )
%gauss_pixel: gauss sim�t�ssal t�bb k�p alapj�n �ll�t el� egy k�pet Summary of this function goes here
%img: eredm�ny
%images:a feldolgozand� k�pek, a k�z�ps� a k�rd�ses k�p, a t�bbi gauss
%sim�t�s�val apjuk a v�glegeset
%szigma:sz�r�s
if exist('szigma','var') == 0
    szigma=2;
end
N=length(images);
[x,y]=size(images{1});
img=zeros(x,y);
 alpha1=(N-1)/(2*szigma);
 window = gausswin(N,alpha1);
 sum=0;
 for k=1:N
     sum=sum+window(k);
 end
 for i=1:x
     for j=1:y
         for k=1:N
             img(i,j)=img(i,j)+images{k}(i,j)*window(k);
         end
         %normaliz�l�s
         img(i,j)=img(i,j)*(1/sum);
     end
 end      
end

