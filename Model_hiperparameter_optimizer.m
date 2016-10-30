clear all; clc; close all;
functionname='Model_hiperparameter_optimizer.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozzá kell adni a függvénykönyvtárat
addpath([functiondir 'Matlab_functions']);
addpath([functiondir 'Matlab_functions\snake']);
addpath([functiondir 'Matlab_functions\snake\snake_extension']);
%%Modell paraméter optimalizáló
%megnyija a korábbi részeredményeket, ami fontos, mert így 
open('LIDC_IDRI_0582.mat');
images=ans.resized_image;
final_masks=ans.final_masks;
options=ans.options;
final=Modelbased_method(images,final_masks,options);
for file=1:length(final_masks)
         [leftcenter, rightcenter]=get_centers(final_masks{file});
         original_masks{file}=rollingball(final_masks{file},leftcenter,rightcenter);
end
mask_withoutrollingball=final_masks;
reference_im=ans.reference_im;
save('LIDC_IDRI_0582_.mat','images','mask_withoutrollingball','options','final','original_masks','reference_im')
%középpont bekamuzása
% bemenet{1}.x=1;bemenet{2}.x=1;
% bemenet{1}.y=1;bemenet{2}.y=1;
% scale=1;
%reference_im=ans.reference_im;

% for file=1:length(final)          
%       %képek kiírása     
%       image=imagewriter(images{file},final{file},bemenet,scale,0,1,0);
%       %eredeti körvonal
%       image=imagewriter(image,final_masks{file},bemenet,scale,1,0,0);
%       %referencia                   
%       %image=imagewriter(image,reference_im{file},bemenet,scale,0,0,1);
%       imwrite(image,strcat(options.prefix,'model_result_',num2str(file),'.png'));
% end
% check_result(final_masks,reference_im,options);
% %modell értékelése
% options.prefix=[options.prefix,'modell'];
% check_result(final,reference_im,options);
