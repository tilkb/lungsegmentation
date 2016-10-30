functionname='image_scale.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozzá kell adni a függvénykönyvtárat
pngFiles = dir([functiondir 'scale_from\*.png']);
%beolvasás kezete
for file=1:length(pngFiles)
    im=imread([functiondir 'scale_from\' pngFiles(file).name]);
    im2=imresize(im,[512 512]);
    imwrite(im2,strcat([functiondir 'scale_to\file'],num2str(file,'%3.3d'),'.png'));
end