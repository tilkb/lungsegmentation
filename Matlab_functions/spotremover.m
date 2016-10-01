function [ result ] = spotremover( mask )
%spotremover: mindkét oldalon csak a legnagyobb egybefüggõ foltot hagyja
%meg a többit eltávolítja
%   mask: bináris kép
%   result: tisztított kép
bal=split(mask,'left');
jobb=split(mask,'right');
%%bal oldal
cc=bwconncomp(bal);
%legnagyobb egybefüggõ maszk megtalálása
numPixels = cellfun(@numel,cc.PixelIdxList);
[~,idx] = max(numPixels);
[x,y]=size(bal);
bal=zeros(x,y);
bal(cc.PixelIdxList{idx}) = 1;
%%jobb oldal
cc=bwconncomp(jobb);
%legnagyobb egybefüggõ maszk megtalálása
numPixels = cellfun(@numel,cc.PixelIdxList);
[~,idx] = max(numPixels);
[x,y]=size(jobb);
jobb=zeros(x,y);
jobb(cc.PixelIdxList{idx}) = 1;
%eredmény elõállítása: két oldal összefûzése
result=bal;
result(:,1:round(y*0.5))=jobb(:,1:round(y*0.5));
end

