function [result] = imagewriter(img,mask,centers,scale,red,green,blue)
%imagewriter: a maszkot rárajzolja a képre a megadott színnel
%   img: eredeti kép
%   mask: a kívánt maszk
%   scale:méretezés
%% beállítások
%a karikázási szin
if exist('red','var') == 0
    red=0;
end
if exist('green','var') == 0
    green=1;
end
if exist('blue','var') == 0
    blue=0;
end
if exist('scale','var') == 0
    scale=1;
end
%% eljárás
 [alfa,beta,gamma]=size(img);
 % ellenõrizni, hogy színes-e a kép
 if (gamma==3)
     result=img;
 else
    result(:,:,1)=img;
    result(:,:,2)=result(:,:,1);
    result(:,:,3)=result(:,:,1);
 end
[x,y,z]=size(img);
[x_mask,y_mask]=size(mask);
meretezes=1/scale;
eltolas_x=x-x_mask*meretezes;
eltolas_y=y-y_mask*meretezes;
%mask2: eltolás utáni matrix
mask2=zeros(x_mask+eltolas_x,y_mask+eltolas_y);
%átméretezés: konvolúció okozta probléma kiküszöbölése és az átméretezéseket is megoldja
if (eltolas_x>0 || eltolas_y>0)
    % konvolúció eltolását megszüntetni   
    for i=1:x_mask
       for j=1:y_mask
          mask2(i+round(eltolas_x/2),j+round(eltolas_y/2))=mask(i,j);
       end
    end 
else
    mask2=mask;
end
if scale~=1
   mask2=imresize(mask,meretezes);
end   
[B,~,N,~] = bwboundaries(mask2);
for j=1:N
    boundary = B{j};
    for i=1:length(boundary)
       result(boundary(i,1),boundary(i,2),1)=red;
       result(boundary(i,1),boundary(i,2),2)=green;
       result(boundary(i,1),boundary(i,2),3)=blue;
    end
end
if exist('centers','var') == 1
    for i=1:length(centers)
        if (gamma~=3)
             result((centers{i}.x+eltolas_x)*meretezes,(centers{i}.y+eltolas_y)*meretezes,1)=red;
             result((centers{i}.x+eltolas_x)*meretezes,(centers{i}.y+eltolas_y)*meretezes,2)=green;
             result((centers{i}.x+eltolas_x)*meretezes,(centers{i}.y+eltolas_y)*meretezes,3)=blue;
        end
    end
end
end

