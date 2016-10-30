clear all; clc; close all;
%%elõre definiált értékek
%szin ami alatt tüdõ terület
colorlimit=30;%50 tûnik ideálisnak
functionname='CTsegmenter.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozzá kell adni a függvénykönyvtárat
addpath([functiondir 'Matlab_functions']);
pngFiles = dir([functiondir 'source_CT\*.png']);


for file=1:length(pngFiles)
    im=imread([functiondir 'source_CT\' pngFiles(file).name]);     
    %im=dicomread([functiondir 'source_CT\' pngFiles(file).name]);
    %img mask
    konstans=1.0/255;%double(max(max(im)));%normalizálás
    imgmask=im<colorlimit;%*max(max(im))/255;
    se = strel('disk',2);
    imgmask = imclose(imgmask,se);
    imgmask = imopen(imgmask,se);
    %szélsõ fölösleges maszkrészek eltávolítása
    szigetek=bwconncomp(imgmask);
    [x,y]=size(imgmask);
    for i=1:szigetek.NumObjects
      if (min(mod(szigetek.PixelIdxList{i},x))==1 ||min(mod(szigetek.PixelIdxList{i},x))==0) 
        imgmask(szigetek.PixelIdxList{i}) = 0;
      end
    end
    %kiírás 
    image=imagewriter(konstans*double(im),imgmask);   
    imwrite(imgmask,strcat([functiondir 'temp\segmented\mask\MASK'],num2str(file,'%3.3d'),'.png'));
    imwrite(image,strcat([functiondir 'temp\segmented\ct\CT'],num2str(file,'%3.3d'),'.png'));   
end



