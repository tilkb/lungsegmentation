function [result_mask] = rollingball(mask,leftcenter,rightcenter)
%RollingBall: Lekerekíti a képet, tüdõszerübbé teszi
% 
%%bal tüdõ
% erodálás szögtartomány
left_erode_from=80;
left_erode_to=240;
% diletálás szögtartomány
left_dilate_from=-45;
left_dilate_to=70;
%%jobb tüdõ
% erodálás szögtartomány
right_erode_from=-60;
right_erode_to=100;
% diletálás szögtartomány
right_dilate_from=110;
right_dilate_to=215;

%% diletálás labda méret
ball_dil = strel('disk',35);
%% erodálás labdaméret
ball_ero= strel('disk',20);
%%eljárás
%bal oldal
left=split(mask,'right');
left_dilate=imclose(left,ball_dil);
left_erode=imopen(left,ball_dil);
[x,y]=size(left);
for i=1:x
   for j=1:round(y*0.5)
      szog=180/pi*atan((leftcenter.x-i)/(j-leftcenter.y));
      if (j<leftcenter.y)
          szog=szog+180;
      end
      %erodálás
      if (szog>=left_erode_from && szog<=left_erode_to) || (szog+360>=left_erode_from && szog+360<=left_erode_to) || (szog-360>=left_erode_from && szog-360<=left_erode_to)
          left(i,j)=left_erode(i,j);
      end
      %diletálás
      if (szog>=left_dilate_from && szog<=left_dilate_to) || (szog+360>=left_dilate_from && szog+360<=left_dilate_to) || (szog-360>=left_dilate_from && szog-360<=left_dilate_to)
          left(i,j)=left_dilate(i,j);
      end
   end
end
%jobb oldal
right=split(mask,'left');
right_dilate=imclose(right,ball_dil);
right_erode=imopen(right,ball_dil);
[x,y]=size(left);
for i=1:x
   for j=round(y*0.5):y
       %szog:[-90..270]
      szog=180/pi*atan((rightcenter.x-i)/(j-rightcenter.y));
      if (j<rightcenter.y)
          szog=szog+180;
      end
      %erodálás
      if (szog>=right_erode_from && szog<=right_erode_to) || (szog+360>=right_erode_from && szog+360<=right_erode_to) || (szog-360>=right_erode_from && szog-360<=right_erode_to)
          right(i,j)=right_erode(i,j);
      end
      %diletálás
      if (szog>=right_dilate_from && szog<=right_dilate_to) || (szog+360>=right_dilate_from && szog+360<=right_dilate_to) || (szog-360>=right_dilate_from && szog-360<=right_dilate_to)
          right(i,j)=right_dilate(i,j);
      end
   end
end
result_mask=left | right;
end

   

