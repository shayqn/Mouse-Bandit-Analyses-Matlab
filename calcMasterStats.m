function masterMouse = calcMasterStats(mouseName, mouseDir)
% CALCMASTERSTATS takes in the name of the mouse and the directory
% from which information on the mouse will be looked
% returns a struct with the following properties:
% masterMouse.name = the name of the mouse
% masterMouse.dates = a cell array of dates at which each session was held
% masterMouse.rewards = a vector of the number of rewards of each session
% masterMouse.numBlocks = a vector of the number of blocks in each session
% masterMouse.blockAccuracy = a 2xnumSessions matrix where the first row is
% the average block accuracy for each session and the second row is the
% standard deviation of the block accuracy for each session
% masterMouse.errorsPreFirstReward = a 2xnumSessions matrix where the first
% row is the average number of errors before the first reward for each
% block of each session and the second row is the standard deviation of
% number of errors before the first reward for each block of each session
% masterMouse.errorsPostFirstReward = a 2xnumSessions matrix where the
% first row is the average number of errors after the first reward for each
% block of each session and the second row is the standard deviation of
% number of errors after the first reward for each block of each session

%sets dataDir as the directory where the function will be looked as
%specified by the user
dataDir = dir(mouseDir);
%change the directory to the one chosen by the user
cd(mouseDir);
%instantiates the number of sessions to be looked at (first letter = j)
numJs = 0;
%total number of files (including unwanted files) in dataDir
numFiles = size(dataDir,1);
%calculates the number of sessions (first letter = j)
for currFolder = 1:numFiles
    currFileName = dataDir(currFolder).name;
    if strcmp(currFileName(1), 'j')
        numJs = numJs + 1;
    end
end
%instantes the folder index at 1
folInd = 1;
%instantiates all of the variables that will be stored as properties of the
%struct to be returned
masterDates = cell(1,numJs);
masterRewards = zeros(1, numJs);
masterBlocks = zeros(1, numJs);
masterBlockAccuracy = zeros(2, numJs);
masterErrorsPreFirst = zeros(2, numJs);
masterErrorsPostFirst = zeros(2, numJs);
%runs through all of the sessions in the directory
for currFolder = 1:numFiles
    %gets the name of the file being looked at
    currFileName = dataDir(currFolder).name;
    %if the file's name starts with a 'j' then the function will change the
    %look at that file and execute the following code
    if strcmp(currFileName(1), 'j')
        %change directory to the next 'j' file
        cd(currFileName);
        %change directory to the mouse selected by the user at that date
        if exist(mouseName,'file')
            cd(mouseName);
            %sets matFiles as all the files of type '.mat' in the directory
            %(stats and pokeHistory)
            matFiles = dir('*.mat');
            %if the directory has this type of '.mat' file(s) the function will
            %execute the following code
            if size(matFiles,1) ~= 0
                %sets the date of the session
                date = currFileName(2:9);
                masterDates{folInd} = date;
                %load all mat files
                for i = 1:size(matFiles,1)
                    load(matFiles(i).name);
                end
                %extracts from the stats and pokeHistory
                % calc regardless of whether trials has been saved since it
                % was modified and I don't want to take any chances. 
                trials = extractTrials(stats,pokeHistory);
                %calculates the blockStats of the trials
                blockStats = calcBlockStats(trials);
                %calculates the sessionStats of the blockStats
                sessionStats = calcSessionStats(blockStats);
                %stores all of the information of sessionStats into the
                %variables that will be used as properties of the struct to be
                %returned
                masterRewards(folInd) = sessionStats(1);
                masterBlocks(folInd) = sessionStats(2);
                masterBlockAccuracy(1,folInd) = sessionStats(3);
                masterBlockAccuracy(2,folInd) = sessionStats(4);
                masterErrorsPreFirst(1,folInd) = sessionStats(5);
                masterErrorsPreFirst(2,folInd) = sessionStats(6);
                masterErrorsPostFirst(1,folInd) = sessionStats(7);
                masterErrorsPostFirst(2,folInd) = sessionStats(8);
                folInd = folInd+1;
            end
       end
            %resets the directory to the one inputted by the user
            cd(mouseDir);
            clear stats pokeHistory
    end
    
end
%sets all of the properties equal to the variables created previously
masterMouse = struct;
masterMouse.name = mouseName;
masterMouse.dates = masterDates;
masterMouse.rewards = masterRewards;
masterMouse.numBlocks = masterBlocks;
masterMouse.blockAccuracy = masterBlockAccuracy;
masterMouse.errorsPreFirstReward = masterErrorsPreFirst;
masterMouse.errorsPostFirstReward = masterErrorsPostFirst;

end