load('QCmotion_included_subjects.mat');
load('result_with_rawROIsig.mat');
ROI_bedny_names={'A1','gngc_frontal','gngc_occ','lang_frontal','lang_occ','math_frontal','math_occ','SMC','V1'};
hemi_list={'lh','rh'};
z_threshold = -3;

table_ROI_bedny_name = cell(18,1);
i_table = 1;
for ihemi = 1:2
    hemi = hemi_list{ihemi};
    for iROI_bedny = 1:length(ROI_bedny_names)
        table_ROI_bedny_name{i_table,1} = [ROI_bedny_names{iROI_bedny},'_',hemi];
        i_table = i_table+1;
    end
end

table_ROI_z_cmp = zeros(size(QCmotionincludedsubjects,1),18);
table_ROI_QC = zeros(size(QCmotionincludedsubjects,1),18);
for iSub = 1:size(QCmotionincludedsubjects,1)
    for iROI_check_index = 1:size(ROI_check_index,1)
        ROI_signal_list = table_ROI_signal(iSub,:);
        
        ROI_ind = ROI_check_index{iROI_check_index,1};
        index_out_ROI = setdiff(1:length(ROI_signal_list),ROI_ind);
        signal_out_ROI = ROI_signal_list(index_out_ROI);
        
        %signal_in_ROI = table_ROI_bedny_signal(iSub,iROI_check_index);
        signal_in_ROI = table_ROI_bedny_signal_raw(iSub,iROI_check_index);
        signal_aug = [signal_out_ROI,signal_in_ROI];
        
        signal_aug_z = (signal_aug - mean(signal_aug))/std(signal_aug);
        table_ROI_z_cmp(iSub,iROI_check_index) = signal_aug_z(end);
        table_ROI_QC(iSub,iROI_check_index) = signal_aug_z(end)>z_threshold;
    end    
end

table_result = [table(table_subID),array2table(table_ROI_z_cmp),array2table(table_ROI_QC)];

table_ROI_bedny_z=cell(1,18) ;
table_ROI_bedny_QC=cell(1,18); 
for i = 1:18
    table_ROI_bedny_z{1,i} = [table_ROI_bedny_name{i},'_z'];
    table_ROI_bedny_QC{1,i} = [table_ROI_bedny_name{i},'_QC'];
end

table_result.Properties.VariableNames = [{'subID'},table_ROI_bedny_z,table_ROI_bedny_QC];
writetable(table_result,'Result_QC_signalRaw_Dropout_z3.csv');

