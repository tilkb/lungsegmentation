function [ result ] = check_result(segmented,reference,options)
%check_result: ki�rt�keli a k�peket, �sszehasonl�tja a referenci�val �s
%   segmented:program �ltal megtal�lt maszk
%   reference:orvos �ltal kijel�lt k�rvonal
%   options
%f�jlba�r�s
fid = fopen([options.prefix 'result.csv'],'w')
fprintf(fid,';teljes �tfed�s;teljes MAD;sz�ras;bal �tfed�s;bal MAD;sz�ras;jobb �tfed�s;jobb MAD;sz�ras\n');
sum=zeros(9);
for i=1:length(segmented)
    %teljes t�d�
    [full_overlap,full_mad,full_szoras]=validate(segmented{i},reference{i});
    result{i+1,2}=full_overlap;
    result{i+1,3}=full_mad;
    result{i+1,4}=full_szoras;
    sum(1)=sum(1)+full_overlap;
    sum(2)=sum(2)+full_mad;
    sum(3)=sum(3)+full_szoras;
    %bal t�d�
    [left_overlap,left_mad,left_szoras]=validate(split(segmented{i},'left'),split(reference{i},'left'));
    result{i+1,5}=left_overlap;
    result{i+1,6}=left_mad;
    result{i+1,7}=left_szoras;
    sum(4)=sum(4)+left_overlap;
    sum(5)=sum(5)+left_mad;
    sum(6)=sum(6)+left_szoras;
    %jobb t�d�
    [right_overlap,right_mad,right_szoras]=validate(split(segmented{i},'right'),split(reference{i},'right'));
    result{i+1,8}=right_overlap;
    result{i+1,9}=right_mad;
    result{i+1,10}=right_szoras;
    sum(7)=sum(7)+right_overlap;
    sum(8)=sum(8)+right_mad;
    sum(9)=sum(9)+right_szoras;
    fprintf(fid,';%s;%s;%s;%s;%s;%s;%s;%s;%s\n',num2str(full_overlap),num2str(full_mad),num2str(full_szoras),num2str(left_overlap),num2str(left_mad),num2str(left_szoras),num2str(right_overlap),num2str(right_mad),num2str(right_szoras));
end
fprintf(fid,'�tlag');
for i=1:9
    temp=sum(i)/length(segmented);
    fprintf(fid,';%s',num2str(temp));
end
fclose(fid);
end

