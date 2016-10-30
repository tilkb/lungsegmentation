%%ModelBuilder, bin�ris k�pekb�l 
functionname='ModelBuilder.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozz� kell adni a f�ggv�nyk�nyvt�rat
addpath([functiondir 'Matlab_functions']);
addpath([functiondir 'Matlab_functions\snake']);
addpath([functiondir 'Matlab_functions\snake\snake_extension']);
%modellk�pek beolvas�sa
pngFiles = dir([functiondir 'Modell_images\*.png']);
Model.Left={};
Model.Right={};
for file=1:length(pngFiles)
    img=double(imread([functiondir 'Modell_images\' pngFiles(file).name]));
    img=img(:,:,1);
    [x,y]=size(img);
    [B,~,N,~] = bwboundaries(img);
    if N>0
      lung1=B{1}; 
      lung1=MakeContourClockwise2D(lung1);
      centery=sum(lung1(:,2))/length(lung1(:,2));
      %bal oldal
      if (centery<y/2)
         Model.Left{length(Model.Left)+1}=TwoD2oneD(lung1);
      else
          Model.Right{length(Model.Right)+1}=TwoD2oneD(lung1);
      end
    end
    if N>1
      lung1=B{2}; 
      lung1=MakeContourClockwise2D(lung1);
      centery=sum(lung1(:,2))/length(lung1(:,2));
      %bal oldal
      if (centery<y/2)
         Model.Left{length(Model.Left)+1}=TwoD2oneD(lung1);
      else
          Model.Right{length(Model.Right)+1}=TwoD2oneD(lung1);
      end  
    end
end 
%%Axi�lis m�ret, mekkor�k az egyes szeleteken a t�d�k
%t�bb betegre is megvizsg�lom
directory = dir([functiondir 'Modell_images\axial\*']);
Model.RightAxial={};
Model.LeftAxial={};
for i=3:length(directory)
pngFiles = dir([functiondir 'Modell_images\axial\',directory(i).name,'\*.png']);

maxleft=0;
maxright=0;
for file=1:length(pngFiles)
     img=double(imread([functiondir 'Modell_images\axial\',directory(i).name,'\' pngFiles(file).name]));
     [x,y]=size(img);
     left=img(:,1:round(y/2));
     right=img(:,round(y/2)+1:y);
      leftlung(i-2,file)=sum(sum(left))/(x*round(y/2));
      rightlung(i-2,file)=sum(sum(right))/(x*(y-round(y/2)-1));
    
     if (rightlung(i-2,file)>maxright)
         maxright=rightlung(i-2,file);
     end
     if ( leftlung(i-2,file)>maxleft)
         maxleft= leftlung(i-2,file);
     end
end
end
%normaliz�l�s
for file=1:length(pngFiles)
     Model.RightAxial{file}=mean(leftlung(:,file))/maxright;
     Model.LeftAxial{file}=mean(rightlung(:,file))/maxleft;
     %sz�r�s kisz�mol�sa ebb�l k�vetkeztetve a megb�zhat�s�gra
     Model.LeftStd(file)=std(leftlung(:,file));
     Model.RightStd(file)=std(rightlung(:,file));
end
save('LungModel.mat','Model');
