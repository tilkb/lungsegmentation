%hozzá kell adni a függvénykönyvtárat
addpath([functiondir 'Matlab_functions']);
addpath([functiondir 'Matlab_functions\snake']);
addpath([functiondir 'Matlab_functions\snake\snake_extension']);
%%Modell paraméter optimalizáló
%megnyija a korábbi részeredményeket, ami fontos, mert így 
open('LIDC_IDRI_0582_.mat');
images=ans.images;
original_masks=ans.original_masks;
final_masks=ans.final;
options=ans.options;
reference_im=ans.reference_im;

%középpont bekamuzása
bemenet{1}.x=1;bemenet{2}.x=1;
bemenet{1}.y=1;bemenet{2}.y=1;
scale=1;
for file=1:length(final_masks)          
      %képek kiírása     
      image=imagewriter(images{file},final_masks{file},bemenet,scale,0,1,0);
      %eredeti körvonal
      image=imagewriter(image,original_masks{file},bemenet,scale,1,0,0);
      %referencia      
      [x,y]=size(final_masks{file});
      reference=imresize(reference_im{file},[x,y]);
      reference_im{file}=reference
      image=imagewriter(image,reference,bemenet,scale,0,0,1);
      imwrite(image,strcat(options.prefix,num2str(file),'.png'));
end
check_result(final_masks,reference_im,options);
%modell értékelése
options.prefix=[options.prefix,'modell'];
check_result(final,reference_im,options);