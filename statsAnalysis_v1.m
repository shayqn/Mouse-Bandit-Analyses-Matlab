% statsAnalysis

numPokes = length(stats.rewards.left); %nothing special here, just 
% need something to get tne number of pokes
numStatRewards = 0;
leftTrials = 0;
rightTrials = 0;
centerErrors = 0;
statsrewards = zeros(1,numPokes);

for i = 1:numPokes
   if stats.rewards.left(i) == 1 || stats.rewards.right(i) == 1
       numStatRewards = numStatRewards + 1;
       statsrewards(i) = 1;
   end
   
   if stats.trials.left(i) == 2
       leftTrials = leftTrials + 1;
   elseif stats.trials.right(i) == 2
       rightTrials = rightTrials + 1;
   end
   
   if stats.errors.center(i) == 1
       centerErrors = centerErrors + 1;
   end
end

numStatRewards
trialBias = leftTrials / rightTrials
centerErrors
