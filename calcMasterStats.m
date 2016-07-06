function masterMouseArray = calcMasterStats(mouseName)

%input name of mouse
%create master array for mouse

% get all the folders of the days
    %cycle through each folder, find mouse's folder in each day
    % load data, run: extractTrials, calcBlockStats, calcSessionStats
    % add curr session stats to master array
%


dataDir = dir(uigetdir);
numFiles = size(dataDir,1);

for currFolder = 1:numFiles
    currFolderName = dataDir(currFolder).name;
    
    if strcmp(currFolderName(1),'j')
    cd(currFolderName)
    
    %load in the data using load(...)
    
    %calculate trials, blockstats, session stats ... 
    
    %add to master array
    
        
    end
    
    
end



end
