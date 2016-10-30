function [ output_masks ] =Modelbased_method(images,masks, options)
z=length(images);
[x,y]=size(images{1});
open('LungModel.mat');
Model=ans.Model;
%%Snake eljárás beállításai
Options.ShapeWeight=0;
Options.SizeWeight=2;
Options.ExpectedSize=0;
Options.Iterations=6;
%%Méretarányosító kiszámítása
tol=round((length(Model.RightAxial)/z)*options.start_high);
ig=round((length(Model.RightAxial)/z)*options.start_high);
%bal oldal
szum1=0;
szum2=0;
for i=options.start_high:options.end_high
    szum1=szum1+sum(sum(masks{i}(:,1:round(y/2))));
    szum2=szum2+sum(sum(masks{i}(:,round(y/2):y)));
end
rate1=2*szum1/(x*y*(options.end_high-options.start_high+1));
%jobb oldal
rate2=2*szum2/(x*y*(options.end_high-options.start_high+1));
%jelenlegi tüdõ és a referencia méretezése
temp=cell2mat(Model.LeftAxial);
rateleft=rate1/mean(temp(tol:ig))
temp=cell2mat(Model.RightAxial);
rateright=rate2/mean(temp(tol:ig));
for i=1:z

    [B,~,N,~] = bwboundaries(masks{i});
    %ha összeér
    if (N==1)
        for j=1:x
          masks{i}(j,round(y/2))=0; 
        end   
        [B,~,N,~] = bwboundaries(masks{i});
    end
    for j=1:x
       masks{i}(j,round(y/2))=0; 
    end
    lung1=B{1};
    lung2=B{2};
    if(mean(lung1(:,2))<mean(lung2(:,2)))
      %bal oldal
      model1=Model.Left;
      %jobb oldal
      model2=Model.Right;
    else
        %jobb oldal
        model1=Model.Right;
        %bal oldal
        model2=Model.Left;
    end
    %%Méret kiszámolása
    if (i>=options.start_high && i<=options.end_high)
        %ha centrális a szelet, akkor nem foglalkozunk a mérettel
        Options.SizeWeight=0;
        leftexpected=0;
        rightexpected=0;
    else
        %nem centrális szeletek esetén foglalkozunk vele
        slice=round((length(Model.RightAxial)/z)*i);
        leftexpected=cell2mat(Model.LeftAxial(slice))*rateleft;
        rightexpected=cell2mat(Model.RightAxial(slice))*rateright;
        Options.SizeWeight=2;
    end
    Options.ExpectedSize=leftexpected;
    [~,mask1]=Snake2D(images{i},lung1,model1,Options);
    Options.ExpectedSize=rightexpected;
    [~,mask2]=Snake2D(images{i},lung2,model2,Options);
    output_masks{i}=mask1 | mask2;
end

end

