clear all; clc; close all;
%% Set options
%a kimenetre generált fájloknál milyen prefixet generáljon.
options.prefix='TOMO01';
%full debug esetén minden lényeges képet legenerál
options.fulldebug=true;
%megbízható képek intervallumának kezdete
options.start_high=39;
%megbízható képek intervallumának vége
options.end_high=48;
%legkisebb kép felbontasa
options.minimal=512;
%legnagyobb feldolgozandó kép felbontása
options.maximal=512;
%% eljárás
functionname='segment.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozzá kell adni a függvénykönyvtárat
addpath([functiondir 'Matlab_functions']);
pngFiles = dir([functiondir 'source\*.png']);
options.prefix=[functiondir 'result\' options.prefix];
%% beolvasás
for file=1:length(pngFiles)
    im=imread([functiondir 'source\' pngFiles(file).name]);
    temp_img=(1/255)*double(im); 
    [alfa,beta,gamma]=size(temp_img);
    % ellenõrizni, hogy színes-e a kép
    if (gamma==3)
        images{file}=temp_img(:,:,1);
    else
       images{file}=temp_img;
    end
end
%% szomszédokat igénylõ képek elõállítása
[a,~]=size(images{1});
scale=1;
%kiszámolni, mekkora kicsinyítésrõl célszerû indulni
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
    %Modell alapúmegközelítés, még a lekeredítés elõtt
    [final_masks]=Modelbased_method(resized_image,final_masks,options);
    %lekerekítés
    for file=1:length(final_masks)
         final_masks{file}=rollingball(final_masks{file},leftcenter{file},rightcenter{file});
    end
    %képek validálása
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
      %képek kiírása
      bemenet{1}=leftcenter{file};bemenet{2}=rightcenter{file};
      image=imagewriter(images{file},final_masks{file},bemenet,scale);
      %referencia rátétele
      image=imagewriter(image,reference_im{file},bemenet,scale,1,0,0);
      %%kiserlet 
      imwrite(image,strcat(options.prefix,'_result_',num2str(file),'.png'));
    end
     check_result(final_masks,reference_im,options);
    scale=scale*2;
end

