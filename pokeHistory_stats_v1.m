%% switching stats 02_21_16 by shay

%using pokeHistory which is a  n by 3 matrix where the first column is
%time, the second is which port was poked, and third is the port the
%reward was delivered to. If no reward, this entry is zero. 

%run pokeStats first.
centerPort = 1;
rightPort = 2;
leftPort = 3;
rightProb = 1;
leftProb = 1;
trialTime = 5;

timevecs = datevec(pokeHistory(:,1));
timenums = datenum(pokeHistory(:,1));
timediffs = etime(timevecs(2:end,:),timevecs(1:end-1,:));
trials = zeros(1,3);


%% extract all the trials to be analyzed
k = 1;
for i = 2:size(pokeHistory,1) 
    if pokeHistory(i-1,2) == 1 && (timediffs(i-1) < trialTime)
        trials(k,:) = pokeHistory(i,:);
        k = k+1;
    end
end

trialTimes = datenum(trials(:,1));

%% some useful numbers from the matrix 'trials'

%cum pokes and rewards
cumCenterPokes = cumsum(trials(:,2) == centerPort);
cumRightPokes = cumsum(trials(:,2) == rightPort);
cumLeftPokes = cumsum(trials(:,2) == leftPort);
cumTotalPokes = cumRightPokes + cumLeftPokes;
cumRightRewards = cumsum(trials(:,3) == rightPort);
cumLeftRewards = cumsum(trials(:,3) == leftPort);
cumTotalRewards = cumRightRewards + cumLeftRewards;

%cumfracts
cumRightRewardFrac = cumRightRewards./cumTotalRewards;
cumLeftRewardFrac = cumLeftRewards./cumTotalRewards;

% num the pokes
numCenterPokes = sum(trials(:,2) == centerPort);
numRightPokes = sum(trials(:,2) == rightPort);
numLeftPokes = sum(trials(:,2) == leftPort);
numTotalPokes = numRightPokes + numLeftPokes;

fracRightPokes = numRightPokes/numTotalPokes;
fracLeftPokes = numLeftPokes/numTotalPokes;

%the rewards
numRightRewards = sum(trials(:,3) == rightPort);
numLeftRewards = sum(trials(:,3) == leftPort);
numTotalRewards = numRightRewards + numLeftRewards;

%cum right and left trials


%% some useful plots
close all

%cum pokes over time
subplot(2,1,1)
plot(trialTimes,cumRightPokes,trialTimes,cumLeftPokes)
datetick('x',13)
legend('Right Pokes','Left Pokes','Location','Northwest')
ylabel('Cumulative number of pokes')


%cum rewards over time
subplot(2,1,2)
plot(trialTimes,cumRightRewardFrac,trialTimes,cumLeftRewardFrac)
hold on
refline(0,rightProb);
hold on
refline(0,leftProb);
datetick('x',13)
legend('Right Rewards Frac','Left Rewards Frac','Location','Northwest')
ylabel('Fraction of rewards')


