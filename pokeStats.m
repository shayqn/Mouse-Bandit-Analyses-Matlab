%PokeStats

%testCum = pokeCumDist(pokeHistory);
%stats = [max(testCum(:,1)) max(testCum(:,2)) max(testCum(:,3)) max(testCum(:,4))]

time = VarName1;
port = VarName3;
action = centerPokeTrigger;
numActions = length(action);
rewardBool = strcmpi(action,'Reward delivered');
noseOutBool = strcmpi(action,'Nose out');
noseIn = strcmpi(action,'Nose in');
portIn = port == 1;
centerIn = zeros(length(action),1);
responseTime = zeros(sum(rewardBool),1);
timeVecs = datevec(time);
rewardTimes = datenum(time(rewardBool));
k = 1;

%% find average time between center poke and reward. 
for i = 1:numActions
    if noseIn(i) && (portIn(i) == 1)
        centerIn(i) = 1;
    end
    
    if rewardBool(i)
        centerOutIndex = find(noseOutBool(1:i),1,'last');
        responseTime(k) = etime(timeVecs(i,:),timeVecs(centerOutIndex,:));
        k = k + 1;
    end
end

figure, plot(rewardTimes,responseTime)
datetick('x',13)
figure, hist(responseTime,20)

%%
numRewards = length(rewardTimes);
numTrials = sum(centerIn);
meanResponseTime = mean(responseTime);
stdResponseTime = std(responseTime);

stats = [numRewards numTrials meanResponseTime stdResponseTime];

