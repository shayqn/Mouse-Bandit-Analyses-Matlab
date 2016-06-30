function trials = extractTrials(stats,pokeHistory)
% trials = extractTrials(stats,pokeHistory)
% This function takes as its inputs: stats, pokeHistory
% And returns the matrix: trials
% 'trials' is a matrix where each row represents a decision poke in a
% succesful trial. It has 4 columns which contain the following
% information: 
    % 1: time
    % 2: port (1 = right, 2 = left)
    % 3: port reward probability
    % 4: reward given (1 / 0)

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


%% create trials matrix
%trials is going to be a numTrials by 4 matrix where the columns are as
%following:
    % 1: time
    % 2: port (1 = right, 2 = left)
    % 3: port reward probability
    % 4: reward given (1 / 0)
trials = zeros(numTrials,4);

% trial times
trials(:,1) = trialTimes;

% trial port
lefttrials = ismember(trialTimes,leftTrialTimes);
righttrials = ismember(trialTimes,rightTrialTimes);
trials(:,2) = righttrials' + (lefttrials.*2)';

%cumulative left and right trials (for plotting)
cumlefttrials = cumsum(lefttrials);
cumrighttrials = cumsum(righttrials);


% reward probabilities
% don't see a way to vectorize this :( will loop through:

%right trials
rightTrialPokes = pokeHistory(rightTrialIndices);
righttrialprob = zeros(numRightTrials,1);
for i = 1:numRightTrials
    righttrialprob(i) = rightTrialPokes(i).rightPortStats.prob;
end

%left trials
leftTrialPokes = pokeHistory(leftTrialIndices);
lefttrialprob = zeros(numLeftTrials,1);
for i = 1:numLeftTrials
    lefttrialprob(i) = leftTrialPokes(i).leftPortStats.prob;
end

% now add them to the trials matrix
trials(righttrials,3) = righttrialprob;
trials(lefttrials,3) = lefttrialprob;

%finally, the rewards:
leftrewards = stats.rewards.left(leftTrialIndices);
rightrewards = stats.rewards.right(rightTrialIndices);

trials(righttrials,4) = rightrewards;
trials(lefttrials,4) = leftrewards;




% %%
% figure
% plot(trialTimes,cumlefttrials,'.k')
% hold on
% plot(trialTimes,cumrighttrials,'.r')
