function [ img ] = gauss_pixel( images,szigma )
%gauss_pixel: gauss simítással több kép alapján állít elõ egy képet Summary of this function goes here
%img: eredmény
%images:a feldolgozandó képek, a középsõ a kérdéses kép, a többi gauss
%simításával apjuk a véglegeset
%szigma:szórás
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
         %normalizálás
         img(i,j)=img(i,j)*(1/sum);
     end
 end      
end

