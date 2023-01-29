addpath(genpath('/export/bedny/Tools/matlab/DPABI_V6.0_210501/'));
addpath(genpath('/export/bedny/Tools/matlab/spm12/'));

load('QCmotion_included_subjects.mat'); % load subjects list

ROI_bedny_names={'A1','gngc_frontal','gngc_occ','lang_frontal','lang_occ','math_frontal','math_occ','SMC','V1'};
hemi_list={'lh','rh'};
root_ROI_bedny = '/export/bedny/Projects/dHCP/sub_pass_QC_func/ROI/ROI_individual_func_nooverlap/';
root_signal_ROI_bedny ='/export/bedny/Projects/dHCP/sub_pass_QC_func/ROI/ROI_signal_mean/';



table_ROI_bedny_signal_raw =  zeros(size(QCmotionincludedsubjects,1),18);

%ROI check index: find atlas index overlaped with bedny ROI
ROI_check_index = cell(18,1);
iROI_check_index = 1;

for iSub = 1:size(QCmotionincludedsubjects,1)  
    for ihemi = 1:2
        hemi = hemi_list{ihemi};
        for iROI_bedny_name = 1:length(ROI_bedny_names)
            subID = QCmotionincludedsubjects.subID{iSub};
            sessID = QCmotionincludedsubjects.sessID{iSub};
            signal_file = [root_signal_ROI_bedny,filesep,ROI_bedny_names{1,iROI_bedny_name},'_sub-',subID,'_',sessID,'.',hemi,'.txt'];
            fid = fopen(signal_file,'r');
            val=fscanf(fid,'%f');
            fclose(fid);
            table_ROI_bedny_signal_raw(iSub,(ihemi-1)*length(ROI_bedny_names)+iROI_bedny_name)=val;
        end
    end
end

load('result.mat');
save('result_with_rawROIsig.mat','table_subID','table_ROI_signal','table_ROI_bedny_signal','ROI_check_index','table_ROI_bedny_signal_raw');

