function [mask] = colormask(img,options)
%colormask egy tüdõre illeszkedõ maszkod ad vissza 
%   a szegmentáció szín alapon megy
%   img:szürke árnyalatos kép
%   options: beállítások:-maxdistance:grafikonon hegy-völgy táv tûrés
%      -startpoint:legsötétebb pixel ahonnan van értelme vizsgálni
%      -cutdistance: aljától való távolság, szélek levágásánál
%   mask: generált maszja a tüdõnek
%eljárás: a hisztogrammon megkeresi az elsõ két hegyet és a közte lévõ
%dombnál végez vágást
%% beállítások
%maximális tolerálható távolság
maxdistance=8;
%kezdõpont
startpoint=55;
%alsó levágási pont
lowcut=-1;
%levágásnál aljától vett távolság
cutdistance=80;
%ha megadják a beállításokat, akkor azokat használjuk
if exist('options','var') ~= 0
      maxdistance=options.maxdistance;
      startpoint=options.startpoint;
      cutdistance=options.cutdistance;
end
%% hisztogram feldolgozása
[array]=imhist(img);
array2=zeros(length(array),1);
for i=2:length(array)-1
  array2(i)=(1/3)*(array(i-1)+array(i)+array(i+1));  
end
max=array2(1);
maxhol=startpoint;
i=startpoint;
%emelkedõ megtalálása
while (maxhol>=i-maxdistance && (i+1<length(array2)))
    i=i+1;
    if (array2(i)>=max)
        max=array2(i);
        maxhol=i;
    end    
end
%lejtõ végének megtalálása
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
%ráhagyás a kvantálási hiba miatt
if (m<=1.2)
   minhol=minhol*(1/length(array));
   lowcut=lowcut*(1/length(array));
end
mask=(img<minhol) & (img>lowcut);

%levágni az oldalso sallangot
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
%jobb szélét levágni
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
%zajszûrés(512x512 re optimalizálva
    se = strel('disk', 4, 4);
    mask=imerode(mask,se);
    se = strel('disk', 12, 4);
    mask = imdilate(mask,se);
end

