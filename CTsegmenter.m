clear all; clc; close all;
%%el�re defini�lt �rt�kek
%szin ami alatt t�d� ter�let
colorlimit=30;%50 t�nik ide�lisnak
functionname='CTsegmenter.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozz� kell adni a f�ggv�nyk�nyvt�rat
addpath([functiondir 'Matlab_functions']);
pngFiles = dir([functiondir 'source_CT\*.png']);


for file=1:length(pngFiles)
    im=imread([functiondir 'source_CT\' pngFiles(file).name]);     
    %im=dicomread([functiondir 'source_CT\' pngFiles(file).name]);
    %img mask
    konstans=1.0/255;%double(max(max(im)));%normaliz�l�s
    imgmask=im<colorlimit;%*max(max(im))/255;
    se = strel('disk',2);
    imgmask = imclose(imgmask,se);
    imgmask = imopen(imgmask,se);
    %sz�ls� f�l�sleges maszkr�szek elt�vol�t�sa
    szigetek=bwconncomp(imgmask);
    [x,y]=size(imgmask);
    for i=1:szigetek.NumObjects
      if (min(mod(szigetek.PixelIdxList{i},x))==1 ||min(mod(szigetek.PixelIdxList{i},x))==0) 
        imgmask(szigetek.PixelIdxList{i}) = 0;
      end
    end
    %ki�r�s 
    image=imagewriter(konstans*double(im),imgmask);   
    imwrite(imgmask,strcat([functiondir 'temp\segmented\mask\MASK'],num2str(file,'%3.3d'),'.png'));
    imwrite(image,strcat([functiondir 'temp\segmented\ct\CT'],num2str(file,'%3.3d'),'.png'));   
end



