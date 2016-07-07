function [ sessionStats ] = calcSessionStats( blockStats )
%CALCSESSIONSTATS takes info from blockStats (concerning each block and
%stores it in sessionStats, an 8x1 matrix (concerning each session) - the information in
%each row are as follows:
% row1 = number of rewards in the whole session
% row2 = number of blocks in the whole session
% row3 = average block accuracy 
% row4 = standard deviation of the block accuracy
% row5 = average number of errors before the first reward of each block
% row6 = standard deviation of the errors before the first reward of each block
% row7 = average number of errors after the first reward of each block
% row8 = standard deviation of errors after the first reward of each block

numRewards = sum(blockStats(:,6));
blockStatsDim = size(blockStats);
numBlocks = blockStatsDim(1);
avgBlockAccuracy = mean(blockStats(:,3));
stdBlockAccuracy = std(blockStats(:,3));
avgErrorsPreFirst = mean(blockStats(:,4));
stdErrorsPreFirst = std(blockStats(:,4));
avgErrorsPostFirst = mean(blockStats(:,5));
stdErrorsPostFirst = std(blockStats(:,5));
sessionStats = [numRewards; numBlocks; avgBlockAccuracy; stdBlockAccuracy;
    avgErrorsPreFirst; stdErrorsPreFirst; avgErrorsPostFirst;
    stdErrorsPostFirst];
end

