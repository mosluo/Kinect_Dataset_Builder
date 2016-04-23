viewNames= {'view01','view02','view03'};
basicPth = 'I:\kinect-dataset(multi-view for activity)';
b=size(viewNames);
totalPersonIdCnt = 10;
videoNumberOfEachView = 95;

% video labels:
% 0->talking
% 1->fighting
% 2->following
% 3->waiting in line
% 4->entering
% 5->gathering
% 6->dismissing

% multi-view ÿ�� view �� ��ͬ video �ŵģ�����һ����Ƶ�Ĳ�ͬ�Ƕ�, ���label��ͬ
% ÿ��view���� 95 ��video������� 95 ����ͬ�� label. ������ labels ���洢

% video01~18 -> talking
labels = zeros(1,18);
% video19 -> fighting
labels = [labels,1];
% video20~35 -> following
tmp = zeros(1,16);
tmp = tmp+2;
labels = [labels,tmp];
% video36~39 -> waiting in line
tmp = zeros(1,4);
tmp = tmp+3;
labels = [labels,tmp];
% video40~47 -> following
tmp = zeros(1,8);
tmp = tmp+2;
labels = [labels,tmp];
% video48~51 -> fighting
tmp = zeros(1,4);
tmp = tmp+1;
labels = [labels,tmp];
% video52~57 -> waiting in line
tmp = zeros(1,6);
tmp = tmp+3;
labels = [labels,tmp];
% video58~62 -> fighting only
tmp = zeros(1,5);
tmp = tmp+1;
labels = [labels,tmp];
% video63~75 -> entering
tmp = zeros(1,13);
tmp = tmp + 4;
labels = [labels,tmp];
% video76~95 -> gathering and dismissing in turn
tmp = [5 6 5 6 5 6 5 6 5 6 5 6 5 6 5 6 5 6 5 6];
labels = [labels,tmp];

for i = 1:b(2)
    viewPth = fullfile(basicPth,viewNames{i});
    %�������е�view��ÿһ��video�е�BBoxes.txt
    for j = 1:videoNumberOfEachView
        videoName=strcat('video',num2str(j,'%02d'));
        BboxesTxtPth = fullfile(viewPth,videoName,'BBoxes.txt');
        showUpList = [0 0 0 0 0 0 0 0 0 0];
        %��ȡBBoxes.txt
        fhandle = fopen(BboxesTxtPth);
        contents = textscan(fhandle,'%u%u%u%u%u%u');
        frameNumber_vector = contents{1};
        personId_vector = contents{2};
        topLeftPointX_vector = contents{3};
        topLeftPointY_vector = contents{4};
        BBoxesWidth_vector = contents{5};
        BBoxesHeight_vector = contents{6};
        n_Records = length(frameNumber_vector);
        %���赱ǰvideo��label
        anno.label = labels(j);
        %��õ�ǰvideo��֡������
        anno.n_Frame = frameNumber_vector(n_Records);
        %����BBoxes.txt�е�ÿһ����¼ (��Ӧ��һ�� bounding boxes)
        %ɨһ��֪������Щ�˴���
        for k = 1:n_Records
            frameNumber = frameNumber_vector(k);
            personId = personId_vector(k);
            topLeftPointX = topLeftPointX_vector(k);
            topLeftPointY = topLeftPointY_vector(k);
            BBoxesWidth = BBoxesWidth_vector(k);
            BBoxesHeight = BBoxesHeight_vector(k);
            %�����
            if showUpList(personId) == 0
                showUpList(personId) = 1;
            end
        end
        anno.n_ShowUp = sum(showUpList);
        %����һ������Ϊ n_ShowUp �� cell, ������ӳ������
        anno.people  = cell(1,anno.n_ShowUp);
        mappingList = cell(1,anno.n_ShowUp);
        %ӳ�������
        counter = 1;
        for k = 1:totalPersonIdCnt
            if showUpList(k) ~= 0
                mappingList{k} = counter;
                % ���id
                anno.people{counter}.id = k;
                counter = counter + 1;
            end
        end
        %��ʼ�� bounding boxes �Ľṹ
        for k = 1:anno.n_ShowUp
            anno.people{k}.time = [];
            anno.people{k}.bbs = [];
        end
        
        %��� bounding boxes ��¼
        for k = 1:n_Records
            frameNumber = frameNumber_vector(k);
            personId = personId_vector(k);
            topLeftPointX = topLeftPointX_vector(k);
            topLeftPointY = topLeftPointY_vector(k);
            BBoxesWidth = BBoxesWidth_vector(k);
            BBoxesHeight = BBoxesHeight_vector(k);
            %�����people�е�����
            indexInPeople = mappingList{personId};
            anno.people{indexInPeople}.time = [anno.people{indexInPeople}.time frameNumber];
            box = [topLeftPointX topLeftPointY BBoxesWidth BBoxesHeight];
            anno.people{indexInPeople}.bbs = [anno.people{indexInPeople}.bbs;box];
        end
        
        %����Ϊ .mat �ļ�����Ӧ video ���ļ�����
        fileName = strcat('view',num2str(i,'%02d'),'_','video',num2str(j,'%02d'),'.mat');
        savePth = fullfile(basicPth,'annotations',fileName);
        save(savePth,'anno');
    end
end