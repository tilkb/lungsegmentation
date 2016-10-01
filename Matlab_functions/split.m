function [im] = split( img,oldal,place)
%split a k�p egyik oldal�t les�t�t�ti
%   img: kiindul� k�p
%   oldal:melyik oldal maradjon meg
%         -'left':bal oldalt t�rli
%         -'right':jobb oldalt t�rli
%  place:az elv�aszt� hely[0..1] tartom�nyban
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


