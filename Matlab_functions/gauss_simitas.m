function [result] = gauss_simitas( img,szigma_inside,vectors,szigma2,szigma_outside )
%gauss_simitas a képen megadott szigmával rendelkezõ normáleloszlású
%simitást végez
%   img: a kezdeti kép
%   szigma_inside: a kép függõleges irányú simításának lapítását határozza
%   meg(befelé)
%   vectors: [n x m] ahol n a felhasznált simító vonalak száma, m a
%   simítóvonal hossza, megegyezik a kép szélességével.
%   szigma2: képek közötti simítás szigmája
%   szigma_outside: a kép függõleges irányú simításának lapítását határozza
%   meg(befelé)
if exist('szigma2','var') == 0
    szigma2=10;
end
if exist('szigma_outside','var') == 0
    szigma_outside=szigma_inside;
end
[x,y]=size(img);
N=x*2+1;
a=length(vectors);
N2=2*a+1;
alpha=(N-1)/(2*szigma_inside);
alpha1=(N-1)/(2*szigma_outside);
alpha2=(N2-1)/(2*szigma2);
%belsõ szóráshoz
window = gausswin(N,alpha);
%külsõ szóráshoz
window1 = gausswin(N,alpha1);
window2 = gausswin(N2,alpha2);
result=zeros(x,y);
for i=1:x
    for j=1:y
        sum=0;
        for sl=1:a
            if (vectors{sl}(j)<i)
                %külsõ simítás
                result(i,j)=result(i,j)+window2(round((N2+1)/2)+sl)*img(i,j)*window1(round((N+1)/2)+1+vectors{sl}(j)-i);           
            else
                %belsõ simítás
                %azért kell hogy egyenlõ legyen 0-ban a két függvény
                %értéke--normalizálja az értékét
                szorzo=window1(round((N+1)/2)+1)/window(round((N+1)/2)+1);
                result(i,j)=result(i,j)+window2(round((N2+1)/2)+sl)*img(i,j)*window(round((N+1)/2)+1+vectors{sl}(j)-i)*szorzo;
            end
            sum=sum+window2(round((N2+1)/2)+sl);   
        end
         result(i,j)=result(i,j)*(1/sum);
    end
end
end

