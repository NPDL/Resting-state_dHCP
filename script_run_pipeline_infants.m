Result = zeros(358,18*18);
 
subInfo=getSubInfo('SubID_passHM_SNR.csv');
errors = zeros(size(subInfo,1),1);
parfor iSub=1:size(subInfo,1)
    try
        sub = subInfo{iSub,1};
        sess= subInfo{iSub,2};
        rMatrix = Pipeline_infants_NocovReg(sub,sess);
        %Result(iSub,:) = reshape(rMatrix,1,18*18);
        Result = reshape(rMatrix,1,18*18);
        outFile = ['rMat_',sub,'_',sess,'.csv'];
        csvwrite(outFile,Result);
    catch
        errors(iSub,1) = 1;
    end
end

% for iSub=1:size(subInfo,1)
%         sub = subInfo{iSub,1};
%         sess= subInfo{iSub,2};
%         rMatrix = Pipeline_Huiqing_covReg(sub,sess);
%         %Result(iSub,:) = reshape(rMatrix,1,18*18);
%         Result = reshape(rMatrix,1,18*18);
%         outFile = ['rMat_',sub,'_',sess,'.csv'];
%         csvwrite(outFile,Result);
% end