load('QCmotion_included_subjects.mat'); % subjects list

ROI_bedny_names={'A1','gngc_frontal','gngc_occ','lang_frontal','lang_occ','math_frontal','math_occ','SMC','V1'};
hemi_list={'lh','rh'};

table_subID = cell(size(QCmotionincludedsubjects,1),1);
table_ROI_signal = zeros(size(QCmotionincludedsubjects,1),100);
table_ROI_bedny_signal =  zeros(size(QCmotionincludedsubjects,1),18);

%ROI check index: find atlas index overlaped with bedny ROI
ROI_check_index = cell(18,1);
iROI_check_index = 1;
for ihemi = 1:2
    hemi = hemi_list{ihemi};
    for iROI_bedny = 1:length(ROI_bedny_names)
        ROI_bedny_name = ROI_bedny_names{iROI_bedny};
        file_ROI_check = ['./ROI_checks',filesep,ROI_bedny_name,'_40wk.',hemi,'.mat'];
        load(file_ROI_check);
        ROI_check_index{iROI_check_index,1} = ROI_check;
        iROI_check_index = iROI_check_index +1;
    end
end


for iSub = 1:size(QCmotionincludedsubjects,1)
            subID = QCmotionincludedsubjects.subID{iSub};
            sessID = QCmotionincludedsubjects.sessID{iSub};
    
            fMRI_root =  ['/export/bedny/Projects/dHCP/dhcp_fmri_pipeline/sub-',subID,'/',sessID,'/func'];
            ROI_root = '/export/bedny/Projects/dHCP/sub_pass_QC_func/ROI/Atlas100_individual';
            file_fMRI = [fMRI_root,filesep,'sub-',subID,'_',sessID,'_task-rest_desc-preproc_bold.nii.gz'];
            file_ROI = [ROI_root,filesep,'sub-',subID,'_',sessID,'_Schaefer2018_100Parcels_17Networks.nii.gz'];
            MaskData = [fMRI_root,filesep,'sub-',subID,'_',sessID,'_task-rest_desc-preproc_space-bold_brainmask.nii.gz'];
            
            file_ROI = [ROI_root,filesep,'sub-',subID,'_',sessID,'_Schaefer2018_100Parcels_17Networks.nii.gz'];
            MaskData = [fMRI_root,filesep,'sub-',subID,'_',sessID,'_task-rest_desc-preproc_space-bold_brainmask.nii.gz'];
            
            %file_ROI_reslice = file_ROI;
            %[Volume_ROI Head_ROI]=y_Reslice(file_ROI,file_ROI_reslice,'',0, MaskData);
            %[Volume_ROI,~, Head_ROI] = y_ReadRPI(MaskData);
            [Volume_ROI, Head_ROI] = y_Read(file_ROI);

            
            AllVolume = file_fMRI;
            ROIDef = {fix(Volume_ROI)};
            OutputName = [];
            MaskData = MaskData;
            IsMultipleLabel = 1;
            
            [ROISignals] = y_ExtractROISignal(AllVolume, ROIDef, OutputName, MaskData, IsMultipleLabel); 
            ROI_Taverage = mean(ROISignals,1);
            %===post-processing in case some labels are missing
            ROI_Taverage_aug = ones(100,1)*mean(ROI_Taverage);

            [MaskData,MaskVox,MaskHead]=y_ReadRPI(MaskData);
            MaskData = fix(MaskData);
            MaskDataOneDim=reshape(MaskData,1,[]);
            MaskIndex = find(MaskDataOneDim);

            MaskROI=y_ReadRPI(file_ROI_reslice);
            MaskROI=fix(reshape(MaskROI,1,[]));
            MaskROI=MaskROI(MaskIndex); %Apply the brain mask

            Element = unique(MaskROI);
            Element(find(isnan(Element))) = []; % ignore background if encoded as nan. Suggested by Dr. Martin Dyrba
            Element(find(Element==0)) = []; % This is the background 0
            ROI_Taverage_aug(Element,1) = ROI_Taverage';    
            
            %=====save result
            table_subID{iSub,1} = subID;
            table_ROI_signal(iSub,:) = ROI_Taverage_aug';
            for iROI_check_index = 1:size(ROI_check_index,1)
                table_ROI_bedny_signal(iSub,iROI_check_index) = mean(ROI_Taverage_aug(ROI_check_index{iROI_check_index}));
            end                    
end

save('result.mat','table_subID','table_ROI_signal','table_ROI_bedny_signal','ROI_check_index');

