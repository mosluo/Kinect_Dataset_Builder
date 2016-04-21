function RegistrateRgbAndDepth(viewName, viewPth)
% scaleRate_RgbToDepth;
% depthImageCroppedRowRange;
% colorImageCroppedColumnRange;
%���ź�ƽ�ƵĲ���
if strcmp(viewName,'view-peizhen')
    scaleRate_RgbToDepth = 2.88000001;
    depthImageCroppedRowRange = [26+1,399+1];
    colorImageCroppedColumnRange = [85+1,596+1];
elseif strcmp(viewName,'view-yongyi')
    scaleRate_RgbToDepth = 2.8856393571727597;
    depthImageCroppedRowRange = [21+1,394+1];
    colorImageCroppedColumnRange = [97+1,608+1];
elseif strcmp(viewName, 'view-weihong')
    scaleRate_RgbToDepth = 2.882497801337617;
    depthImageCroppedRowRange = [32+1,405+1];
    colorImageCroppedColumnRange = [71+1,582+1];
end

%����view�е�����video
for i = 1:length(dir(fullfile(viewPth)))
    videoName=strcat('video',num2str(i,'%02d'));
    colorImageDirectPth = fullfile(viewPth,videoName,'ColorImage');
    depthImageDirectPth = fullfile(viewPth,videoName,'DepthImage');
    %��ȡColorImage Ŀ¼������ rgb ͼƬ������
    colorFiles = dir(fullfile(colorImageDirectPth,'*.jpg'));
    %��ȡDepthImage Ŀ¼������ depth ͼƬ������
    depthFiles = dir(fullfile(depthImageDirectPth,'*.png'));
    
    %�ü� rgb ͼƬ
    for j = 1:length(colorFiles)
        filePth = fullfile(colorImageDirectPth,colorFiles(j).name);
        image = imread(filePth);
        %rgb ͼƬ resize
        image=imresize(image,floor([1080.0/scaleRate_RgbToDepth 1920.0/scaleRate_RgbToDepth]));
        image=image(:,colorImageCroppedColumnRange(1):colorImageCroppedColumnRange(2),:);
        %���ü����ͼƬ����ԭͼƬ
        imwrite(image,filePth);
    end
    %�ü� depth ͼƬ
    for j = 1:length(depthFiles)
        filePth = fullfile(depthImageDirectPth,depthFiles(j).name);
        image = imread(filePth);
        image=image(depthImageCroppedRowRange(1):depthImageCroppedRowRange(2),:);
        %���ü����ͼƬ����ԭͼƬ
        imwrite(image,filePth);
    end
end