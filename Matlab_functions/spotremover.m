function [ result ] = spotremover( mask )
%spotremover: mindk�t oldalon csak a legnagyobb egybef�gg� foltot hagyja
%meg a t�bbit elt�vol�tja
%   mask: bin�ris k�p
%   result: tiszt�tott k�p
bal=split(mask,'left');
jobb=split(mask,'right');
%%bal oldal
cc=bwconncomp(bal);
%legnagyobb egybef�gg� maszk megtal�l�sa
numPixels = cellfun(@numel,cc.PixelIdxList);
[~,idx] = max(numPixels);
[x,y]=size(bal);
bal=zeros(x,y);
bal(cc.PixelIdxList{idx}) = 1;
%%jobb oldal
cc=bwconncomp(jobb);
%legnagyobb egybef�gg� maszk megtal�l�sa
numPixels = cellfun(@numel,cc.PixelIdxList);
[~,idx] = max(numPixels);
[x,y]=size(jobb);
jobb=zeros(x,y);
jobb(cc.PixelIdxList{idx}) = 1;
%eredm�ny el��ll�t�sa: k�t oldal �sszef�z�se
result=bal;
result(:,1:round(y*0.5))=jobb(:,1:round(y*0.5));
end

