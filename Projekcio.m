%%be�ll�t�sok
%referencia gy�rt�s legyen?
%sz�r�s
sigma=4;
%milyen messzire �r el a sz�r�s
N=5;
%szeletsz�m
db=60;
%v�gs� gauss sz�r� szigma
sig_filter=2;
functionname='Projekcio.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozz� kell adni a f�ggv�nyk�nyvt�rat
addpath([functiondir 'Matlab_functions']);
  %a referenci�k legy�rt�sa
  %axi�lis szeletek beolvas�sa
  pngFiles = dir([functiondir 'temp\segmented\mask\*.png']);
  asd=imread([functiondir 'temp\segmented\mask\' pngFiles(1).name]); 
  [x,y,z]=size(asd);
  im=zeros(x,y,length(pngFiles));
for file=1:length(pngFiles)
    im(:,:,file)=double(imread([functiondir 'temp\segmented\mask\' pngFiles(file).name])); 
end
step=round(x/db);
%sim�t�s(�tmos�d�s) n�lk�li tomoszint�zis k�pek el��ll�t�sa
szeletek=zeros(db,y,length(pngFiles),3);
for slice=1:step:(x)
    valami=mean(im(slice:min(slice+step,x),:,:),1);
    [a1,a2,a3,a4]=size(valami);
    tmp=reshape(valami,[a2 a3,a4]); 
    img=tmp(:,:,1)>0.5;
    imwrite(imrotate(img,-90),strcat([functiondir 'reference\szelet_'],num2str((slice-1)/step+1),'.png'));
end

pngFiles = dir([functiondir 'temp\segmented\ct\*.png']);
%axi�lis szeletek beolvas�sa
  asd=imread([functiondir 'temp\segmented\ct\' pngFiles(1).name]); 
  [x,y,z]=size(asd);
  im=zeros(x,y,length(pngFiles),z);
 for file=1:length(pngFiles)
    im(:,:,file,:)=(1/255)*double(imread([functiondir 'temp\segmented\ct\' pngFiles(file).name])); 
end
step=round(x/db);
%sim�t�s(�tmos�d�s) n�lk�li tomoszint�zis k�pek el��ll�t�sa
szeletek=zeros(db,y,length(pngFiles),3);
for slice=1:step:(x)
    valami=mean(im(slice:min(slice+step,x),:,:,:),1);
    [a1,a2,a3,a4]=size(valami);
    tmp=reshape(valami,[a2 a3 a4]);
    szeletek((slice-1)/step+1,:,:,:)=tmp;
    imwrite(imrotate(tmp,-90),strcat([functiondir 'temp\project\szelet_'],num2str((slice-1)/step+1),'.png'));
end
%gauss ssim�t�ssal k�pek k�z�tti �tmos�s
  N2=2*N+1;
  alpha=(N2-1)/(2*sigma);
  window = gausswin(N2,alpha);
  sum=0;
  for i=1:length(window)
    sum=sum+window(i);
  end
  szeletek_atmosodassal=zeros(db,y,length(pngFiles),3);
  for slice=1:db
    for vastag=max(slice-N,1):min(slice+N,db)
       szeletek_atmosodassal(slice,:,:,:)=szeletek_atmosodassal(slice,:,:,:)+(szeletek(vastag,:,:,:)*(window(abs(vastag-slice+N+1))/sum)); 
    end
    result=reshape(szeletek_atmosodassal(slice,:,:,:),[y length(pngFiles)  3]);
    imwrite(imrotate(result,-90),strcat([functiondir 'temp\project\szelet_osszemosva_'],num2str(slice),'.png')); 
    imwrite(imrotate(result,-90),strcat([functiondir 'source\szelet_'],num2str(slice),'.png'));
  end
%sim�t�s a koron�lis tomoseleten 1 szelet szinten:
  for slice=1:db
     H = fspecial('gaussian',9,sig_filter);
    img=reshape(szeletek_atmosodassal(slice,:,:,1),[y length(pngFiles)]);
    result(:,:,1)=imfilter(img,H);
    img=reshape(szeletek_atmosodassal(slice,:,:,2),[y length(pngFiles)]);
    result(:,:,2)=imfilter(img,H);
    img=reshape(szeletek_atmosodassal(slice,:,:,3),[y length(pngFiles)]);
    result(:,:,3)=imfilter(img,H);
    
   imwrite(imrotate(result,-90),strcat([functiondir 'temp\project\szelet_vegso_'],num2str(slice,'%3.3d'),'.png'));
  end
  

  
  
  

