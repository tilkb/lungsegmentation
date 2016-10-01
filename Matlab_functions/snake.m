function [ mask,snake_mask ] = snake(img,initmask,addmask,options,file)
%snake: active contour algoritmussal el��ll�t egy  �j maszkot, majd
%kicser�li a megadott sz�gtartom�nyban az eredeti maszokot az �jra
%img: original image
%initmask: initial mask for the algorithm
%addmask: original mask which is modified with the new mask
%file: melyik k�pr�l van sz�(debug-n�l fontos)
%mask: result binary image
%%be�ll�t�sok
%iter�ci�k sz�ma active contour-n�l
iter=30;
%baloldal sz�gtartom�ny kezdete(fok)
left_start=-85;
%baloldal sz�gtartom�ny v�ge(fok)
left_end=70;
%jobboldal sz�gtartom�ny kezdete(fok)
right_start=100;
%jobboldal sz�gtartom�ny v�ge(fok)
right_end=265;
%a bal �s jobb ter�let hat�ra 0..1 intervalumon
kozep=0.5;
%%elj�r�s
%maszkok �tm�retez�se
[x,y]=size(img);
[x_mask,y_mask]=size(initmask);
eltolas_x=x-x_mask;
eltolas_y=y-y_mask;
add_mask=zeros(x,y);
imask=zeros(x,y);
if (eltolas_x>0 || eltolas_y>0)
    % konvol�ci� eltol�s�t megsz�ntetni   
    for i=1:x_mask
       for j=1:y_mask
          imask(i+round(eltolas_x/2),j+round(eltolas_y/2))=initmask(i,j);
       end
    end 
else
    imask=initmask;
end
%hozz�ad�shoz felhaszn�lt maszkot is �t kell m�retezni
[x_mask,y_mask]=size(addmask);
eltolas_x=x-x_mask;
eltolas_y=y-y_mask;
if (eltolas_x>0 || eltolas_y>0)
    % konvol�ci� eltol�s�t megsz�ntetni   
    for i=1:x_mask
       for j=1:y_mask
          add_mask(i+round(eltolas_x/2),j+round(eltolas_y/2))=addmask(i,j);
       end
    end 
else
    add_mask=addmask;
end
%�j kont�r keres�s
ujmask=activecontour(img,imask, iter);
%k�pjav�t�s
se = strel('disk',4);
ujmask=imopen(ujmask,se);
snake_mask=ujmask;
if (options.fulldebug==true)
    debugimage=imagewriter(img,ujmask);
    imwrite(debugimage,strcat(options.prefix,'_snake_',num2str(file),'.png'));
end
%%kett� �sszeolvaszt�sa
[leftcenter,rightcenter]=get_centers(imask);
mask=add_mask;
%bal oldal
for i=1:x
   for j=1:round(y*kozep)
      szog=180/pi*atan((leftcenter.x-i)/(j-leftcenter.y));
      if (j<leftcenter.y)
          szog=szog+180;
      end
      if (szog>=left_start && szog<=left_end) || (szog+360>=left_start && szog+360<=left_end) || (szog-360>=left_start && szog-360<=left_end)
           %2 mask �sszead�sa
          if (mask(i,j)==0)
            mask(i,j)=ujmask(i,j);
          end
      end
   end
end 
%jobb oldal
for i=1:x
   for j=round(y*kozep):y
       %szog:[-90..270]
      szog=180/pi*atan((rightcenter.x-i)/(j-rightcenter.y));
      if (j<rightcenter.y)
          szog=szog+180;
      end
      if (szog>=right_start && szog<=right_end) || (szog+360>=right_start && szog+360<=right_end) || (szog-360>=right_start && szog-360<=right_end)
         %2 mask �sszead�sa
          if (mask(i,j)==0)
            mask(i,j)=ujmask(i,j);
          end
      end
   end
end 
%foltok elt�vol�t�sa �s lesim�t�s
mask=spotremover(mask);
%simitas
 se = strel('disk',10);
mask=imclose(mask,se);

end

