function [ masks ] = snake_method(images,pre_masks,options)
%snake_method: active contour elj�r�st haszn�lva �ll�t el� maszkokat 
%   a megb�zhat� szeletek kezdeti maszkj�hoz, sz�n alap� szegment�l�st
%   v�gez, a t�bbit a szomsz�dos maszk felhaszn�l�s�val hozza l�tre
%   images: az eredeti sz�rt k�pek
%   pre_masks:maszk amihez az �jat hozz� kell illeszteni
%%be�ll�t�sok
%limit: a sz�n alap� szegment�l�s mekkorra tal�lati ar�nyn�l tekintse az adott
%pixelt megfelel�n�l
color_rate=0.5;

[x,y]=size(images{1});
image=zeros(x,y);

for file=options.start_high:options.end_high
    cm=colormask(images{file});
    image=image+cm;
end
image=image>=(options.end_high-options.start_high)*color_rate;
%megb�zhat� szeletek
for file=options.start_high:options.end_high
    [masks{file},active{file}]=snake(images{file},image,pre_masks{file},options,file);
end
%h�ts� szeletek
init=active{options.end_high};
for file=options.end_high+1:length(images)
    [masks{file},init]=snake(images{file},init,pre_masks{file},options,file);
end
%els� szeletek
init=active{options.start_high};
for file=options.start_high-1:-1:1
    [masks{file},init]=snake(images{file},init,pre_masks{file},options,file);
end
end

