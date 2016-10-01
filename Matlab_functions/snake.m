function [ mask,snake_mask ] = snake(img,initmask,addmask,options,file)
%snake: active contour algoritmussal elõállít egy  új maszkot, majd
%kicseréli a megadott szögtartományban az eredeti maszokot az újra
%img: original image
%initmask: initial mask for the algorithm
%addmask: original mask which is modified with the new mask
%file: melyik képrõl van szó(debug-nál fontos)
%mask: result binary image
%%beállítások
%iterációk száma active contour-nál
iter=30;
%baloldal szögtartomány kezdete(fok)
left_start=-85;
%baloldal szögtartomány vége(fok)
left_end=70;
%jobboldal szögtartomány kezdete(fok)
right_start=100;
%jobboldal szögtartomány vége(fok)
right_end=265;
%a bal és jobb terölet határa 0..1 intervalumon
kozep=0.5;
%%eljárás
%maszkok átméretezése
[x,y]=size(img);
[x_mask,y_mask]=size(initmask);
eltolas_x=x-x_mask;
eltolas_y=y-y_mask;
add_mask=zeros(x,y);
imask=zeros(x,y);
if (eltolas_x>0 || eltolas_y>0)
    % konvolúció eltolását megszüntetni   
    for i=1:x_mask
       for j=1:y_mask
          imask(i+round(eltolas_x/2),j+round(eltolas_y/2))=initmask(i,j);
       end
    end 
else
    imask=initmask;
end
%hozzáadáshoz felhasznált maszkot is át kell méretezni
[x_mask,y_mask]=size(addmask);
eltolas_x=x-x_mask;
eltolas_y=y-y_mask;
if (eltolas_x>0 || eltolas_y>0)
    % konvolúció eltolását megszüntetni   
    for i=1:x_mask
       for j=1:y_mask
          add_mask(i+round(eltolas_x/2),j+round(eltolas_y/2))=addmask(i,j);
       end
    end 
else
    add_mask=addmask;
end
%új kontúr keresés
ujmask=activecontour(img,imask, iter);
%képjavítás
se = strel('disk',4);
ujmask=imopen(ujmask,se);
snake_mask=ujmask;
if (options.fulldebug==true)
    debugimage=imagewriter(img,ujmask);
    imwrite(debugimage,strcat(options.prefix,'_snake_',num2str(file),'.png'));
end
%%kettõ összeolvasztása
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
           %2 mask összeadása
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
         %2 mask összeadása
          if (mask(i,j)==0)
            mask(i,j)=ujmask(i,j);
          end
      end
   end
end 
%foltok eltávolítása és lesimítás
mask=spotremover(mask);
%simitas
 se = strel('disk',10);
mask=imclose(mask,se);

end

