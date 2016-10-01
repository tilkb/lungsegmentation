function [mask] = colormask(img,options)
%colormask egy t�d�re illeszked� maszkod ad vissza 
%   a szegment�ci� sz�n alapon megy
%   img:sz�rke �rnyalatos k�p
%   options: be�ll�t�sok:-maxdistance:grafikonon hegy-v�lgy t�v t�r�s
%      -startpoint:legs�t�tebb pixel ahonnan van �rtelme vizsg�lni
%      -cutdistance: alj�t�l val� t�vols�g, sz�lek lev�g�s�n�l
%   mask: gener�lt maszja a t�d�nek
%elj�r�s: a hisztogrammon megkeresi az els� k�t hegyet �s a k�zte l�v�
%dombn�l v�gez v�g�st
%% be�ll�t�sok
%maxim�lis toler�lhat� t�vols�g
maxdistance=8;
%kezd�pont
startpoint=55;
%als� lev�g�si pont
lowcut=-1;
%lev�g�sn�l alj�t�l vett t�vols�g
cutdistance=80;
%ha megadj�k a be�ll�t�sokat, akkor azokat haszn�ljuk
if exist('options','var') ~= 0
      maxdistance=options.maxdistance;
      startpoint=options.startpoint;
      cutdistance=options.cutdistance;
end
%% hisztogram feldolgoz�sa
[array]=imhist(img);
array2=zeros(length(array),1);
for i=2:length(array)-1
  array2(i)=(1/3)*(array(i-1)+array(i)+array(i+1));  
end
max=array2(1);
maxhol=startpoint;
i=startpoint;
%emelked� megtal�l�sa
while (maxhol>=i-maxdistance && (i+1<length(array2)))
    i=i+1;
    if (array2(i)>=max)
        max=array2(i);
        maxhol=i;
    end    
end
%lejt� v�g�nek megtal�l�sa
i=maxhol;
minhol=i;
min=array2(i);
while ((minhol>=i-maxdistance) && (i+1<length(array2)))
    i=i+1;
    if (array2(i)<=min)
        min=array2(i);
        minhol=i;
    end    
end
[x,y]=size(img);
m=0;
for i=1:x
    for j=1:y
        if m<img(i,j)
            m=img(i,j);
        end
    end
end
%r�hagy�s a kvant�l�si hiba miatt
if (m<=1.2)
   minhol=minhol*(1/length(array));
   lowcut=lowcut*(1/length(array));
end
mask=(img<minhol) & (img>lowcut);

%lev�gni az oldalso sallangot
bal=0;
i=1;
while (i<=y && bal==i-1)
    if ( mask(x-cutdistance,i)==1)
        bal=i;
        for j=1:x
            mask(j,i)=0;
        end
    end
    i=i+1;
end
%jobb sz�l�t lev�gni
jobb=y+1;
i=y;
while (i>0 && jobb==i+1)
    if ( mask(x-cutdistance,i)==1)
        jobb=i;
        for j=1:x
            mask(j,i)=0;
        end
    end
    i=i-1;
end
%zajsz�r�s(512x512 re optimaliz�lva
    se = strel('disk', 4, 4);
    mask=imerode(mask,se);
    se = strel('disk', 12, 4);
    mask = imdilate(mask,se);
end

