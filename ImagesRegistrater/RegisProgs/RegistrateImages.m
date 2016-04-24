function RegistrateImages(rootPthOfVideos)
% Reading parameters from 'rootPthOfVideos\registerParams.txt'
regisPrmTxtPth = fullfile(rootPthOfVideos,'registerParams.txt');
fid = fopen(regisPrmTxtPth);
tline = fgetl(fid);
tline = str2num(tline);
scaleRate_RgbToDepth = tline(7);
% +1 ����Ϊ matlab �е� index ���Ǵ� 1 �����
depthImageCroppedRowRange = [tline(3)+1 tline(4)+1];
colorImageCroppedColumnRange = [tline(1)+1 tline(2)+1];

% ����, Kinect 2 ��Ĭ���ռ���rgb֡�Ĵ�С: 1920 x 1080
origColorWidth = 1920.0;
origColorHeight = 1080.0;

%���ڵ�ǰview�е�����video
for i = 1:length(dir(fullfile(rootPthOfVideos)))
    videoName=strcat('video',num2str(i,'%02d'));
    colorImageDirectPth = fullfile(rootPthOfVideos,videoName,'ColorImage');
    depthImageDirectPth = fullfile(rootPthOfVideos,videoName,'DepthImage');
    bodyIndexImageDirectPth = fullfile(rootPthOfVideos,videoName,'BodyIndexImage');
    infraredImageDirectPth = fullfile(rootPthOfVideos,videoName,'InfraredImage');
    %��ȡColorImage Ŀ¼������ rgb ͼƬ������
    colorFiles = dir(fullfile(colorImageDirectPth,'*.jpg'));
    %��ȡDepthImage Ŀ¼������ depth ͼƬ������
    depthFiles = dir(fullfile(depthImageDirectPth,'*.png'));
    %��ȡBodyIndexImage Ŀ¼������ body index ͼƬ������
    bodyIndexFiles = dir(fullfile(bodyIndexImageDirectPth,'*.jpg'));
    %��ȡInfraredImage Ŀ¼������ infrared ͼƬ������
    infraredFiles = dir(fullfile(infraredImageDirectPth,'*.jpg'));
    
    %�ü� rgb ͼƬ
    for j = 1:length(colorFiles)
        filePth = fullfile(colorImageDirectPth,colorFiles(j).name);
        image = imread(filePth);
        %rgb ͼƬ resize
        image=imresize(image,floor([origColorHeight/scaleRate_RgbToDepth origColorWidth/scaleRate_RgbToDepth]));
        image=image(:,colorImageCroppedColumnRange(1):colorImageCroppedColumnRange(2),:);
        %%���ü����ͼƬ����ԭͼƬ
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
    %�ü� body index ͼƬ
    for j = 1:length(bodyIndexFiles)
        filePth = fullfile(bodyIndexImageDirectPth,bodyIndexFiles(j).name);
        image = imread(filePth);
        %bodyIndexImage���ӽǺ� depth ��һ��, ���Ժ� depth image �Ĳü���Χ��ͬ
        image=image(depthImageCroppedRowRange(1):depthImageCroppedRowRange(2),:);
        %���ü����ͼƬ����ԭͼƬ
        imwrite(image,filePth);
    end
    %�ü� infrared ͼƬ
    for j = 1:length(infraredFiles)
        filePth = fullfile(infraredImageDirectPth,infraredFiles(j).name);
        image = imread(filePth);
        %infraredImage���ӽǺ� depth ��һ��, ���Ժ� depth image �Ĳü���Χ��ͬ
        image=image(depthImageCroppedRowRange(1):depthImageCroppedRowRange(2),:);
        %���ü����ͼƬ����ԭͼƬ
        imwrite(image,filePth);
    end
end