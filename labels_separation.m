clear

global MyLabelMatrix SepLabelMatrix
% 假设 MyLabelMatrix 是你的三维标签矩阵
in1=tom_mrcread('2_delmito.mrc'); % labels of membrane
in2=tom_mrcread('../deconved.mrc'); % tomogram
MyLabelMatrix = in1.Value;
deconv=in2.Value;

%
SepLabelMatrix = zeros(size(MyLabelMatrix));

% 创建一个 GUI 窗口
figure;

% 添加一个滑动条
slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', size(MyLabelMatrix, 3), ...
    'Value', 1, 'Units', 'normalized', 'Position', [0.2 0.9 0.6 0.05], ...
    'Callback', @(src, event) sliderCallback(src, event,deconv));

% 初始化当前 z 平面
current_z = round(get(slider, 'Value'));

% 显示初始 z 平面的标签图像
subplot(1, 3, 1);
imshow(MyLabelMatrix(:,:,current_z)==0, []);
subplot(1, 3, 2);
imshow(deconv(:,:,current_z), []);
subplot(1, 3, 3);
imshow(SepLabelMatrix(:,:,current_z)==0, []);


% 添加一个按钮用于seperate label
SepButton = uicontrol('Style', 'pushbutton', 'String', 'toRight', ...
    'Units', 'normalized', 'Position', [0.1 0.9 0.05 0.05], ...
    'Callback', @(src, event)  toRightCallback(src, event, slider,deconv));

SepButton2 = uicontrol('Style', 'pushbutton', 'String', 'toLeft', ...
    'Units', 'normalized', 'Position', [0.9 0.9 0.05 0.05], ...
    'Callback', @(src, event)  toLeftCallback(src, event, slider,deconv));

% save按钮
saveButton = uicontrol('Style', 'pushbutton', 'String', 'save', ...
    'Units', 'normalized', 'Position', [0.1 0.1 0.05 0.05], ...
    'Callback', @(src, event)  saveCallback(src, event));

saveButton2 = uicontrol('Style', 'pushbutton', 'String', 'save', ...
    'Units', 'normalized', 'Position', [0.9 0.1 0.05 0.05], ...
    'Callback', @(src, event)  saveCallback2(src, event));


% 回调函数，响应滑动条的变化
function sliderCallback(hObject, ~, deconv)
    global MyLabelMatrix SepLabelMatrix
    current_z = round(get(hObject, 'Value'));
    subplot(1, 3, 1);
    imshow(MyLabelMatrix(:,:,current_z)==0, []);
    subplot(1, 3, 2);
    imshow(deconv(:,:,current_z), []);
    subplot(1, 3, 3);
    imshow(SepLabelMatrix(:,:,current_z)==0, []);
end

function  toRightCallback(~, ~, slider,deconv)
    global MyLabelMatrix SepLabelMatrix
    % 获取当前滑动条的值，即当前的 z 平面
    current_z = round(get(slider, 'Value'));
    
    
    h = imrect;
    if isempty(h)
        return; % 用户没有选择区域，直接返回
    end
    pos = getPosition(h);
    delete(h);
    
    x = round(pos(1));
    y = round(pos(2));
    w = round(pos(3));
    h = round(pos(4));
    
    % 获取对应位置的 label 
    selected_labels = MyLabelMatrix(y:y+h, x:x+w, current_z);
    selected_labels = unique(selected_labels);
    selected_labels(selected_labels==0)=[];
    disp(selected_labels);

    % 删除位置
    for i = 1:length(selected_labels)
        label=selected_labels(i);
        SepLabelMatrix(MyLabelMatrix == label) = label;
        MyLabelMatrix(MyLabelMatrix == label) = 0;        
    end
    
    % 更新显示    
    subplot(1, 3, 1);
    imshow(MyLabelMatrix(:,:,current_z)==0, []);
    subplot(1, 3, 2);
    imshow(deconv(:,:,current_z), []);
    subplot(1, 3, 3);
    imshow(SepLabelMatrix(:,:,current_z)==0, []);  

    % 设置滑动条的值为当前 z 平面，保持在删除 label 时的 z 平面
    set(slider, 'Value', current_z);
end

function  toLeftCallback(~, ~, slider,deconv)
    global MyLabelMatrix SepLabelMatrix
    % 获取当前滑动条的值，即当前的 z 平面
    current_z = round(get(slider, 'Value'));
    
    
    h = imrect;
    if isempty(h)
        return; % 用户没有选择区域，直接返回
    end
    pos = getPosition(h);
    delete(h);
    
    x = round(pos(1));
    y = round(pos(2));
    w = round(pos(3));
    h = round(pos(4));
    
    % 获取对应位置的 label 
    selected_labels = SepLabelMatrix(y:y+h, x:x+w, current_z);
    selected_labels = unique(selected_labels);
    selected_labels(selected_labels==0)=[];
    disp(selected_labels);

    % 删除位置
    for i = 1:length(selected_labels)
        label=selected_labels(i);
        MyLabelMatrix(SepLabelMatrix == label) = label;
        SepLabelMatrix(SepLabelMatrix == label) = 0;        
    end
    
    % 更新显示    
    subplot(1, 3, 1);
    imshow(MyLabelMatrix(:,:,current_z)==0, []);
    subplot(1, 3, 2);
    imshow(deconv(:,:,current_z), []);
    subplot(1, 3, 3);
    imshow(SepLabelMatrix(:,:,current_z)==0, []);  

    % 设置滑动条的值为当前 z 平面，保持在删除 label 时的 z 平面
    set(slider, 'Value', current_z);
end

function saveCallback(~, ~)
    global MyLabelMatrix
    tom_mrcwrite(MyLabelMatrix)
end
function saveCallback2(~, ~)
    global SepLabelMatrix
    tom_mrcwrite(SepLabelMatrix)
end