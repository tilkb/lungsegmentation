function [ masks ] = snake_method(images,pre_masks,options)
%snake_method: active contour eljárást használva állít elõ maszkokat 
%   a megbízható szeletek kezdeti maszkjához, szín alapú szegmentálást
%   végez, a többit a szomszédos maszk felhasználásával hozza létre
%   images: az eredeti szûrt képek
%   pre_masks:maszk amihez az újat hozzá kell illeszteni
%%beállítások
%limit: a szín alapú szegmentálás mekkorra találati aránynál tekintse az adott
%pixelt megfelelõnél
color_rate=0.5;

[x,y]=size(images{1});
image=zeros(x,y);

for file=options.start_high:options.end_high
    cm=colormask(images{file});
    image=image+cm;
end
image=image>=(options.end_high-options.start_high)*color_rate;
%megbízható szeletek
for file=options.start_high:options.end_high
    [masks{file},active{file}]=snake(images{file},image,pre_masks{file},options,file);
end
%hátsó szeletek
init=active{options.end_high};
for file=options.end_high+1:length(images)
    [masks{file},init]=snake(images{file},init,pre_masks{file},options,file);
end
%elsõ szeletek
init=active{options.start_high};
for file=options.start_high-1:-1:1
    [masks{file},init]=snake(images{file},init,pre_masks{file},options,file);
end
end

