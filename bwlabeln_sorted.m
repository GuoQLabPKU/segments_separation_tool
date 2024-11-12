clear
tom_mrcread('memb_label.mrc');
BW=ans.Value;
[L,num] = bwlabeln(BW,18);
unique_labels = get_labels(L);
unique_labels=sortrows(unique_labels,2);
L2 = process_labels2(L,unique_labels);
tom_mrcwrite(L2);

function unique_labels = get_labels(L)
    
    % 找到所有的标签
    unique_labels = unique(L(:));
    unique_labels(unique_labels == 0) = []; % 去掉背景标签
    
    for i = 1:length(unique_labels)
        current_label = unique_labels(i);
        
        % 找到当前标签的所有位置
        [rows, ~, ~] = ind2sub(size(L), find(L == current_label));
        
        % 计算连续像素的数量
        unique_labels(i,2)=size(rows,1);

    end
end

function L_processed = process_labels2(L,unique_labels)
    L_processed = zeros(size(L));
 
    current_new_label = 1;
    
    for i = 1:size(unique_labels,1)
        current_label = unique_labels(i,1);
        
        
        % 将连通区域赋予新的值
        L_processed(L == current_label) = current_new_label;
        
        % 更新下一个新的标签值
        current_new_label = current_new_label + 1;
    end
end
