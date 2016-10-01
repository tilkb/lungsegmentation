function pcimg=imgpolarcoord(img,radius,angle, cx,cy)
% IMGPOLARCOORD converts a given image from cartesian coordinates to polar
% coordinates.
%
% Input:
%        img  : bidimensional image.
%      radius : radius length (# of pixels to be considered).--high
%      resultimage
%      angle  : # of angles to be considered for decomposition.--lenght of
%      the result image
%          cx : centerpoint x
%          cy : centerpoint y
% Output:
%       pcimg : polar coordinate image.


   if nargin < 1
      error('Please specify an image!');
   end
   
   img         = double(img);
   [rows,cols] = size(img);
   
   if exist('radius','var') == 0
      radius = min(round(rows/2),round(cols/2))-1;
   end
   
   if exist('angle','var') == 0
      angle = 360;
   end
   if exist('cx','var') == 0
      cx = round(rows/2);
   end
   if exist('cy','var') == 0
      cy = round(cols/2);
   end
  
   pcimg = zeros(radius,angle);
   i     = 1;
   [size_x, size_y]=size(img);
   for r=0:radius
      j = 1;
      for a=0:2*pi/angle:2*pi-2*pi/angle
          pcimg(i,j)=0;
          im_x=cx+round(r*sin(a));
          im_y=cy+round(r*cos(a));
          if (im_y>1 && im_y<size_y-1 && im_x>1 && im_x<size_x-1)
              %átlagolás
              pcimg(i,j) =(1/6)*( 2*img(im_x,im_y)+img(im_x+1,im_y)+img(im_x,im_y+1)+img(im_x-1,im_y)+img(im_x,im_y-1));
          end
          j = j + 1;
      end
      i = i + 1;
   end
end