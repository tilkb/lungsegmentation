function [im] = split( img,oldal,place)
%split a kép egyik oldalát lesötétíti
%   img: kiinduló kép
%   oldal:melyik oldal maradjon meg
%         -'left':bal oldalt törli
%         -'right':jobb oldalt törli
%  place:az elváasztó hely[0..1] tartományban
if ((exist('place','var') == 0) || (place<0) || (place>1))
    place=0.5;
end
im=img;
[x,y]=size(im);
if strcmp(oldal,'left')
    for i=1:x
      for j=1:round(y*place)
          im(i,j)=0;
      end
    end
end
if strcmp(oldal,'right')
    for i=1:x
      for j=round(y*place):y
          im(i,j)=0;
      end
    end
end
end


