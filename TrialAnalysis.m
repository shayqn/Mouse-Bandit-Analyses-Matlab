%% Analyze Switching Behavior
% description
%load stats:


%Parameters:
rewardWindow = 3; % in seconds
iti = 2; % in seconds
blockRange = 10; % num of rewards needed to switch blocks
maxProb = 1; %probability we are switching between. 


%% Extract trials
trials = extractTrials(stats,pokeHistory);

%% Calculate # of blocks in session & which trials each block started on
numRewards = sum(stats.rewards.left) + sum(stats.rewards.right);
%consider only completed blocks.
numBlocks = floor(numRewards/blockRange);

%calculate first trial of each block
blocks = zeros(1,numBlocks);
k=1;
for i = 0:blockRange:(blockRange*(numBlocks-1))
    %need to consider the special case where the first trial is rewarded
    if i == 0 && trials(1,3) == 1
        blocks(1) = 1;
        k = k + 1;
    else
        blocks(k) = find(cumsum(trials(:,3)) == i,1)+1;
        k = k+1;
    end
end

%% analyze blocks
numLeftTrials = zeros(1,numBlocks);
numRightTrials = zeros(1,numBlocks);
firstRewardedTrial = zeros(1,numBlocks);
numTrials2Reward = zeros(1,numBlocks);
numErrorsAfterReward = zeros(1,numBlocks);
blockType = zeros(1,numBlocks); %left (2) or right (1). 

for i = 1:numBlocks
    blockStart = blocks(i);
    %determine end of block
    if i == numBlocks
        blockEnd = size(trials,1);
    else
        blockEnd = blocks(i+1) - 1;
    end
    
    %pull out trials of current block. for simplicity.
    currBlock = trials(blockStart:blockEnd,:);
    
    %determine if it is a left or right block
    rewardedTrial = find(currBlock(:,3)==maxProb,1);
    if currBlock(rewardedTrial,2) == 1
        blockType(i) = 1;
    elseif currBlock(rewardedTrial,2) == 2
        blockType(i) = 2;
    else
        error('Something is messed');
    end
    
    %number of left and right trials
    numLeftTrials(i) = sum(currBlock(:,2)==2);
    numRightTrials(i) = sum(currBlock(:,2)==1);
    
    %errors to first reward, errors after first reward.
    firstRewardedTrial(i) = find(currBlock(:,3)==1,1);
    numTrials2Reward(i) = firstRewardedTrial(i) - 1;
    
    numErrorsAfterReward(i) = abs(sum(currBlock(firstRewardedTrial(i):end,3)-1));
    %this last calculation is perhaps a silly thing to do. We want to
    %calculate the number of errors after the first reward, so what I did
    %was take the 'reward' column, but subtract 1 from each row. So now
    %every rewarded trial is a 0 and non-rewarded trial is a -1. we want to
    %know how many -1's there are, so we take the absolute sum.
end

%% analyzing left vs trials in left vs right blocks.
leftBlocks = blockType == 2;
rightBlocks = blockType == 1;

leftinleft = sum(numLeftTrials(leftBlocks));
leftinright = sum(numLeftTrials(rightBlocks));
rightinright = sum(numRightTrials(rightBlocks));
rightinleft = sum(numRightTrials(leftBlocks));

correctRatioLeft = leftinleft / (leftinleft + rightinleft)
incorrectRatioLeft = leftinright / (rightinright + leftinright);
correctRatioRight = rightinright / (rightinright + leftinright)
incorrectRatioRight = rightinleft / (leftinleft + rightinleft);

%%averaging errors pre and post first reward
errors2rewardLeft(1) = mean(numTrials2Reward(leftBlocks));
errors2rewardLeft(2) = std(numTrials2Reward(leftBlocks))
errors2rewardRight(1) = mean(numTrials2Reward(rightBlocks));
errors2rewardRight(2) = std(numTrials2Reward(rightBlocks))
errors2reward(1) = mean(numTrials2Reward);
errors2reward(2) = std(numTrials2Reward)

errorsPostrewardLeft(1) = mean(numErrorsAfterReward(leftBlocks));
errorsPostrewardLeft(2) = std(numErrorsAfterReward(leftBlocks))
errorsPostrewardRight(1) = mean(numErrorsAfterReward(rightBlocks));
errorsPostrewardRight(2) = std(numErrorsAfterReward(rightBlocks))
errorsPostreward(1) = mean(numErrorsAfterReward);
errorsPostreward(2) = std(numErrorsAfterReward)

%% plot ratios
figure
bar([correctRatioLeft,incorrectRatioRight; incorrectRatioLeft, correctRatioRight],'stacked');
specs = {'Left Blocks','Right Blocks'};
set(gca,'xticklabel',specs)


%% Plot numTrials2Reward and numErrorsAfterReward
figure 
plot(1:numBlocks,numTrials2Reward)
hold on
plot(1:numBlocks,numErrorsAfterReward)
legend('# trials to reward','# errors after first reward')

%% Error trials
errortrials = cumsum(trials(trials(:,3)==0,2));
errortimes = trials(trials(:,3)==0,1);
figure, plot(errortimes,errortrials)
