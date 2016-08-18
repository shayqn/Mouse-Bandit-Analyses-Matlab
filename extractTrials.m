function trials = extractTrials(stats,pokeHistory)
% trials = extractTrials(stats,pokeHistory)
% This function takes as its inputs: stats, pokeHistory
% And returns the matrix: trials
% 'trials' is a matrix where each row represents a decision poke in a
% succesful trial. It has 4 columns which contain the following
% information: 
    % 1: time
    % 2: port (1 = right, 2 = left)
    % 3: right port reward probability
    % 4: left port reward probability
    % 5: reward given (1 / 0)
%Note: extractTrials was changed on 08/03/16 to include the probabilities
%of both ports for each trial. Previously there was only 4 columns, with
%the 3rd being the reward probability of the port poked and the 4th the
%reward boolean. 

% create a vector 'timePoked' where each entry represents a poke, and the
% value is the number of seconds since the first poke. This is also
% calculated in pokeAnalysis_v1, but I wanted to add it here so this can
% stand as an independent function. 
numPokes = length(pokeHistory);
timePoked = zeros(1,numPokes);
firstPoke = datevec(pokeHistory(1).timeStamp);
for i = 1:numPokes
    timePoked(i) = etime(datevec(pokeHistory(i).timeStamp),firstPoke);
end

%% calculate total number of trials
numLeftTrials = sum(stats.trials.left == 2);
numRightTrials = sum(stats.trials.right == 2);
numTrials = numLeftTrials + numRightTrials;


%% determine which actual pokes were trials
trialPokes = find((stats.trials.left == 2) + (stats.trials.right == 2));
trialTimes = timePoked(trialPokes);
leftTrialIndices = find(stats.trials.left == 2);
rightTrialIndices = find(stats.trials.right == 2);
leftTrialTimes = timePoked(leftTrialIndices);
rightTrialTimes = timePoked(rightTrialIndices);
allTrialIndices = sort([leftTrialIndices,rightTrialIndices]);


%% create trials matrix
%trials is going to be a numTrials by 4 matrix where the columns are as
%following:
    % 1: time
    % 2: port (1 = right, 2 = left)
    % 3: right port reward probability
    % 4: left port reward probability
    % 5: reward given (1 / 0)
trials = zeros(numTrials,4);

% trial times
trials(:,1) = trialTimes;

% trial port
lefttrials = ismember(trialTimes,leftTrialTimes);
righttrials = ismember(trialTimes,rightTrialTimes);
trials(:,2) = righttrials' + (lefttrials.*2)';

% reward probabilities
% don't see a way to vectorize this :( will loop through:

%all trials
allTrialPokes = pokeHistory(allTrialIndices);

for i = 1:numTrials
    trials(i,3) = allTrialPokes(i).rightPortStats.prob;
    trials(i,4) = allTrialPokes(i).leftPortStats.prob;
end

%finally, the rewards:
leftrewards = stats.rewards.left(leftTrialIndices);
rightrewards = stats.rewards.right(rightTrialIndices);

trials(righttrials,5) = rightrewards;
trials(lefttrials,5) = leftrewards;
