%Result = zeros(358,18*18);
 
%subInfo=getSubInfo('SubID_passHM_SNR.csv');
errors = zeros(81,4);
parfor Sub=1:81
%for Sub=1:81
    ROISignals_c = [];
    outFile = ['rMat_',num2str(Sub),'.csv'];
    if isfile(outFile)
        continue;
    end
     try  
        for Sess = 1:4
            subFolder=['/export/bedny/Projects/REST_ALLSUBS/dHCP_adults/data_preproc/conn_',num2str(Sub),'/session_',num2str(Sess),'/'];
            if exist(subFolder, 'dir')      
                    %sub = subInfo{iSub,1};
                    %sess= subInfo{iSub,2};
                    ROISignals = Pipeline_adults_multisess_anatalign_aCompCor_scrubbing_erosion(num2str(Sub),num2str(Sess));
                    ROISignals_c = [ROISignals_c;ROISignals];
                    %Result(iSub,:) = reshape(rMatrix,1,18*18);
    %                 Result = reshape(rMatrix,1,18*18);
    %                 outFile = ['rMat_',num2str(Sub),'_',num2str(Sess),'.csv'];
    %                 csvwrite(outFile,Result);

            end
        end
        rMatrix = corr(ROISignals_c);    
        Result = reshape(rMatrix,1,18*18);
        outFile = ['rMat_',num2str(Sub),'.csv'];
        csvwrite(outFile,Result);
    catch
        errors(Sub,Sess) = 1;
    end
end

% info_sub_sess = [];
% for Sub=1:97
%     for Sess = 1:4
%         subFolder=['/export/bedny/Projects/REST_ALLSUBS/dHCP_adults/data/conn_',num2str(Sub),'/sess',num2str(Sess),'/'];
%         if exist(subFolder, 'dir')            
%             info_sub_sess = [info_sub_sess;[Sub,Sess]];
%         end
%     end
% end
% csvwrite('info_sub_sess.csv',info_sub_sess);
% for iSub=1:size(subInfo,1)
%         sub = subInfo{iSub,1};
%         sess= subInfo{iSub,2};
%         rMatrix = Pipeline_Huiqing_covReg(sub,sess);
%         %Result(iSub,:) = reshape(rMatrix,1,18*18);
%         Result = reshape(rMatrix,1,18*18);
%         outFile = ['rMat_',sub,'_',sess,'.csv'];
%         csvwrite(outFile,Result);
% end