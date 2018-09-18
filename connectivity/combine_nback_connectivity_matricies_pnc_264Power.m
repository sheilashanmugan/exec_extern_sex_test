bblidsN21 = importdata('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/nbackNetwork_264PowerPNC_paths.csv') ;
%bblidsN21(1153,:)=[]; %1153 scanid 6507

nsub = length(bblidsN21);


networkN21 = NaN(264,264,nsub); %inititate the 3D 21by21 matrix by all subjects
for i = 1:nsub
    id=char(bblidsN21(i));
    lineOfCode = sprintf(char(bblidsN21(i)));
    % Now, execute lineOfCode just as if you'd typed 
    % >> Ai=[i:i]' into the command window
    E=dlmread(id) ; %import each txt file
    networkN21(:,:,i) = E;  %put it into the final 3D matrix
end




powerConsensusPath = '/home/sshanmugan/PowerConsensus.1D';
powerConsensus = dlmread(powerConsensusPath);
nsubj = size(networkN21,3);
% Switch unknown to community 14
powerConsensus(powerConsensus==-1) = 14;
comIDs = unique(powerConsensus);
ncom = length(comIDs);
% Define unique within-network edges
within = bsxfun(@eq,powerConsensus,powerConsensus');

figure; imagesc(within)
within = squareform(within - diag(diag(within)));

E1 = E + diag(repmat(NaN,[length(E),1]));
wmbat = zeros(length(comIDs));
for i = 1:length(comIDs)
com1 = comIDs(i);
for j = 1:length(comIDs)
com2 = comIDs(j);
wmbat(i,j) = nanmean(nanmean(E1(powerConsensus==com1,powerConsensus==com2)));
end
end
figure; imagesc(wmbat)



% Preallocate outputs
within_overall = NaN(nsubj,1);
between_overall = NaN(nsubj,1);
between_vec = NaN(ncom,nsubj);
wbmat = NaN(ncom,ncom,nsubj);
total_overall = NaN(nsubj,1);

for s = 1:nsubj
    E = squeeze(networkN21(:,:,s));
    E1 = E + diag(repmat(NaN,[length(E),1]));
    
    % Whole-brain/overall
    E(logical(eye(size(E)))) = 0;
    Evec = squareform(E - diag(diag(E)));
    within_overall(s) = mean(Evec(logical(within)));
    between_overall(s) = mean(Evec(~logical(within)));
    total_overall(s) = mean(Evec); %global connectivity?
    
    % Single network
    for i = 1:ncom
        com1 = comIDs(i);
        between_vec(i,s) = nanmean(nanmean(E1(powerConsensus==com1,powerConsensus~=com1)));
    end
    
    % Network-by-network
    for i = 1:ncom
        com1 = comIDs(i);
        for j = i:ncom
            com2 = comIDs(j);
            wbmat(i,j,s) = nanmean(nanmean(E1(powerConsensus==com1,powerConsensus==com2)));
        end
    end
    
end


wbmat1 = transpose(squeeze(wbmat(:,1,:)));
wbmat2 = transpose(squeeze(wbmat(:,2,:)));
wbmat3 = transpose(squeeze(wbmat(:,3,:)));
wbmat4 = transpose(squeeze(wbmat(:,4,:)));
wbmat5 = transpose(squeeze(wbmat(:,5,:)));
wbmat6 = transpose(squeeze(wbmat(:,6,:)));
wbmat7 = transpose(squeeze(wbmat(:,7,:)));
wbmat8 = transpose(squeeze(wbmat(:,8,:)));
wbmat9 = transpose(squeeze(wbmat(:,9,:)));
wbmat10 = transpose(squeeze(wbmat(:,10,:)));
wbmat11 = transpose(squeeze(wbmat(:,11,:)));
wbmat12 = transpose(squeeze(wbmat(:,12,:)));
wbmat13 = transpose(squeeze(wbmat(:,13,:)));
wbmat14 = transpose(squeeze(wbmat(:,14,:)));

between_vec_t =transpose(between_vec);




csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/within_overall.csv',within_overall);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/between_overall.csv',between_overall);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/between_vec.csv',between_vec_t);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat1.csv',wbmat1);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat2.csv',wbmat2);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat3.csv',wbmat3);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat4.csv',wbmat4);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat5.csv',wbmat5);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat6.csv',wbmat6);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat7.csv',wbmat7);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat8.csv',wbmat8);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat9.csv',wbmat9);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat10.csv',wbmat10);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat11.csv',wbmat11);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat12.csv',wbmat12);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat13.csv',wbmat13);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/wbmat14.csv',wbmat14);
csvwrite('/data/jux/BBL/projects/exec_extern_sex/inputData/connectivity/nbackNetworks_264PowerPNC/total_overall.csv',total_overall);
