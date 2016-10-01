function [result] = gauss_simitas( img,szigma_inside,vectors,szigma2,szigma_outside )
%gauss_simitas a k�pen megadott szigm�val rendelkez� norm�leloszl�s�
%simit�st v�gez
%   img: a kezdeti k�p
%   szigma_inside: a k�p f�gg�leges ir�ny� sim�t�s�nak lap�t�s�t hat�rozza
%   meg(befel�)
%   vectors: [n x m] ahol n a felhaszn�lt sim�t� vonalak sz�ma, m a
%   sim�t�vonal hossza, megegyezik a k�p sz�less�g�vel.
%   szigma2: k�pek k�z�tti sim�t�s szigm�ja
%   szigma_outside: a k�p f�gg�leges ir�ny� sim�t�s�nak lap�t�s�t hat�rozza
%   meg(befel�)
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
%bels� sz�r�shoz
window = gausswin(N,alpha);
%k�ls� sz�r�shoz
window1 = gausswin(N,alpha1);
window2 = gausswin(N2,alpha2);
result=zeros(x,y);
for i=1:x
    for j=1:y
        sum=0;
        for sl=1:a
            if (vectors{sl}(j)<i)
                %k�ls� sim�t�s
                result(i,j)=result(i,j)+window2(round((N2+1)/2)+sl)*img(i,j)*window1(round((N+1)/2)+1+vectors{sl}(j)-i);           
            else
                %bels� sim�t�s
                %az�rt kell hogy egyenl� legyen 0-ban a k�t f�ggv�ny
                %�rt�ke--normaliz�lja az �rt�k�t
                szorzo=window1(round((N+1)/2)+1)/window(round((N+1)/2)+1);
                result(i,j)=result(i,j)+window2(round((N2+1)/2)+sl)*img(i,j)*window(round((N+1)/2)+1+vectors{sl}(j)-i)*szorzo;
            end
            sum=sum+window2(round((N2+1)/2)+sl);   
        end
         result(i,j)=result(i,j)*(1/sum);
    end
end
end

