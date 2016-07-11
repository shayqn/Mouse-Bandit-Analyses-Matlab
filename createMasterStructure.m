function [ masterStruct ] = createMasterStructure( mouseNames )
%CREATEMASTERSTRUCTURE takes in a cell array of mouse names and outputs a 
% master structure that is has the following fields:
%     masterStruct:
%         byMouse:
%             MouseName1:
%                 name: name of the mouse
%                 dates: cell array of the dates that the data was taken from
%                 rewards: array of ints representing the number of rewards 
%                     the mouse received corresponding to the dates in the "dates" field
%                 numBlocks: an array of ints representing the number of blocks that 
%                     took place corresponding to each date in the "dates" field
%                 blockAccuracy: a 2 x numDates matrix with the average block accuracy
%                     for each date in the first row and the standard deviation of the
%                     block accuracy in the second row
%                 errorsPreFirstReward: a 2 x numDates matrix with the average 
%                     number of errors before the first reward for each date 
%                     in the first row and the standard deviation of the number
%                     of errors before the first reward in the second row
%                 errorsPostFirstReward: a 2 x numDates matrix with the average 
%                     number of errors after the first reward for each date 
%                     in the first row and the standard deviation of the number
%                     of errors after the first reward in the second row
%             MouseName2:
%                 "   same as above
%             MouseName3:
%                 "   same as above
%             etc.
%         byCategory:
%                 rewards: a cell containing the number of rewards achieved
%                     by each mouse on each date and the avg and std rewards 
%                     achieved on each date
%                 numBlocks: a cell containing the number of blocks that occured
%                     on each date for each mouse's session and the avg and std
%                     number of blocks on each date
%                 blockAccuracy: a cell containing the average block accuracy
%                     that each mouse achieved on each date and an avg and std
%                     block accuracy for each date
%                 errorsPreFirstReward: a cell containing the average number
%                     of errors before the first reward of each block for each
%                     mouse on each date and an avg and std errors before the first
%                     reward for each date
%                 errorsPostFirstReward: a cell containing the average number
%                     of errors after the first reward of each block for each
%                     mouse on each date and an avg and std errors after the first
%                     reward for each date

%allows the user to set the directory from which the data from each date
%will be used -> declares the varible for the number of mice and uses it to
%use the function calcMasterStats on each of the mice names that the was
%passed in the parameter -> miceStats now contains a masterStats struct for
%each mouse passed in the parameter
dir = uigetdir;
numMice = length(mouseNames);
for i = 1:numMice
    miceStats(i) = calcMasterStats(mouseNames{i}, dir);
end


%% create master struct for all mice
%instantiates masterStruct and creates the fields byMouse and byCategory
masterStruct = struct;
masterStruct.byMouse = struct;
masterStruct.byCategory = struct;
%fills in the information for the masterStruct.byCategory field using the
%data from miceStats
for i = 1:numMice
    currentMouse = miceStats(i);
    currentMouseName = currentMouse.name;
    masterStruct.byMouse.(currentMouseName) = currentMouse;
end

%% cycle through each field - add data from each mouse
%gets the dates to be looked at and the number of dates to be looked at
dates = miceStats(1).dates;
numDates = length(dates);
%creates a standardCell on which all of the fields in
%masterStruct.byCategory will be modeled 
cellCols = numDates + 1;
cellRows = numMice + 3;
standardCell = cell(cellRows, cellCols);
for i = 2:cellCols
    standardCell{1,i} = dates{i - 1};
end
for i = 2:cellRows - 2
    standardCell{i,1} = miceStats(i - 1).name;
end
standardCell{cellRows - 1,1} = 'avg';
standardCell{cellRows,1} = 'std';

%specifies each type of cell (rewardsCell, numBlocksCell,
%blockAccuracyCell, errorsPreFirstCell, errorsPostFirstCell) by putting the
%name of the cell in the upperleft corner (1,1)
rewardsCell = standardCell;
rewardsCell{1,1} = 'REWARDS';
numBlocksCell = standardCell;
numBlocksCell{1,1} = 'NUMBLOCKS';
blockAccuracyCell = standardCell;
blockAccuracyCell{1,1} = 'BLOCKACCURACY';
errorsPreFirstCell = standardCell;
errorsPreFirstCell{1,1} = 'ERRORSPREFIRSTREWARD';
errorsPostFirstCell = standardCell;
errorsPostFirstCell{1,1} = 'ERRORSPOSTFIRSTREWARD';

%for loop uses the masterStruct.byMouse field to fill in the data of each 
%cells instantiated above
%excludes the standard deviation for blockAccuracy, errorsPreFirstReward,
%and errorsPostFirstReward
%does not fill in the average and standard deviation for each date
for row = 2:cellRows - 2
    currentMouseName = standardCell{row,1};
    currentMouseData = masterStruct.byMouse.(currentMouseName);
    for column = 2:cellCols
        rewardsCell{row,column} = currentMouseData.rewards(column - 1);
        numBlocksCell{row,column} = currentMouseData.numBlocks(column - 1);
        blockAccuracyCell{row,column} = currentMouseData.blockAccuracy(1,column - 1);
        errorsPreFirstCell{row,column} = currentMouseData.errorsPreFirstReward(1,column - 1);
        errorsPostFirstCell{row,column} = currentMouseData.errorsPostFirstReward(1,column - 1);
    end
end

%fills in the standard deviation and mean for each date of each type of
%cell (field)... completes the cell so that all data has been transfered
%into these cells from the field masterStruct.byMouse
for column = 2:cellCols
    rewardsCell{end - 1, column} = mean([rewardsCell{2:end-2,column}]);
    rewardsCell{end, column} = std([rewardsCell{2:end - 2,column}]);
    numBlocksCell{end - 1, column} = mean([numBlocksCell{2:end-2,column}]);
    numBlocksCell{end, column} = std([numBlocksCell{2:end - 2,column}]);
    blockAccuracyCell{end - 1, column} = mean([blockAccuracyCell{2:end-2,column}]);
    blockAccuracyCell{end, column} = std([blockAccuracyCell{2:end - 2,column}]);
    errorsPreFirstCell{end - 1, column} = mean([errorsPreFirstCell{2:end-2,column}]);
    errorsPreFirstCell{end, column} = std([errorsPreFirstCell{2:end - 2,column}]);
    errorsPostFirstCell{end - 1, column} = mean([errorsPostFirstCell{2:end-2,column}]);
    errorsPostFirstCell{end, column} = std([errorsPostFirstCell{2:end - 2,column}]);
    
end

%sets the fields of rewards, numBlocks, blockAccuracy,
%errorsPreFirstReward, and errorsPostFirstReward equal to their respective
%cells so that the user can access them in the struct once it is returned
masterStruct.byCategory.rewards = rewardsCell;
masterStruct.byCategory.numBlocks = numBlocksCell;
masterStruct.byCategory.blockAccuracy = blockAccuracyCell;
masterStruct.byCategory.errorsPreFirstReward = errorsPreFirstCell;
masterStruct.byCategory.errorsPostFirstReward = errorsPostFirstCell;


end

