clear all; clc; close all;
%% Set options
%a kimenetre gener�lt f�jlokn�l milyen prefixet gener�ljon.
options.prefix='TOMO01';
%full debug eset�n minden l�nyeges k�pet legener�l
options.fulldebug=true;
%megb�zhat� k�pek intervallum�nak kezdete
options.start_high=39;
%megb�zhat� k�pek intervallum�nak v�ge
options.end_high=48;
%legkisebb k�p felbontasa
options.minimal=512;
%legnagyobb feldolgozand� k�p felbont�sa
options.maximal=512;
%% elj�r�s
functionname='segment.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozz� kell adni a f�ggv�nyk�nyvt�rat
addpath([functiondir 'Matlab_functions']);
pngFiles = dir([functiondir 'source\*.png']);
options.prefix=[functiondir 'result\' options.prefix];
%% beolvas�s
for file=1:length(pngFiles)
    im=imread([functiondir 'source\' pngFiles(file).name]);
    temp_img=(1/255)*double(im); 
    [alfa,beta,gamma]=size(temp_img);
    % ellen�rizni, hogy sz�nes-e a k�p
    if (gamma==3)
        images{file}=temp_img(:,:,1);
    else
       images{file}=temp_img;
    end
end
%% szomsz�dokat ig�nyl� k�pek el��ll�t�sa
[a,~]=size(images{1});
scale=1;
%kisz�molni, mekkora kicsiny�t�sr�l c�lszer� indulni
while(a*scale>options.minimal)
    scale=scale*0.5;
end
original_prefix=options.prefix;
while (scale<=1) && (options.maximal>=scale*a)
    options.prefix=[original_prefix '_' num2str(scale) '_'];
    for file=1:length(pngFiles)
        resized_image{file}=imresize(images{file},scale);
        [filtered_image{file},grad{file}]=kepgenerator(resized_image{file});
    end  
    [grad_masks,leftcenter,rightcenter]=grad_method(grad,filtered_image,options);
    [final_masks]=snake_method(resized_image,grad_masks,options);
    %Modell alap�megk�zel�t�s, m�g a lekered�t�s el�tt
    [final_masks]=Modelbased_method(resized_image,final_masks,options);
    %lekerek�t�s
    for file=1:length(final_masks)
         final_masks{file}=rollingball(final_masks{file},leftcenter{file},rightcenter{file});
    end
    %k�pek valid�l�sa
      referenceFiles = dir([functiondir 'reference\*.png']);
      for file=1:length(referenceFiles)
         tmp_im=((1/255)*double(imread([functiondir 'reference\' referenceFiles(file).name])))>0.6;
         [alfa,beta,gamma]=size(tmp_im);
         if (gamma==3)
             reference_im{file}=tmp_im(:,:,1);
         else
             reference_im{file}=tmp_im;
         end
      end  
    for file=1:length(pngFiles)          
      %k�pek ki�r�sa
      bemenet{1}=leftcenter{file};bemenet{2}=rightcenter{file};
      image=imagewriter(images{file},final_masks{file},bemenet,scale);
      %referencia r�t�tele
      image=imagewriter(image,reference_im{file},bemenet,scale,1,0,0);
      %%kiserlet 
      imwrite(image,strcat(options.prefix,'_result_',num2str(file),'.png'));
    end
     check_result(final_masks,reference_im,options);
    scale=scale*2;
end

