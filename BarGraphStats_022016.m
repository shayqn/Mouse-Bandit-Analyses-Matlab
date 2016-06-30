%% making a little graph

numTrials = [black(2) long(2) short(2) spot(2)];
numRewards = [black(1) long(1) short(1) spot(1)];
fracCorrect = numRewards./numTrials;
meanResponseTimes = [black(3) long(3) short(3) spot(3)];
stdResponseTimes = [black(4) long(4) short(4) spot(4)];

%% response times
figure
bar(meanResponseTimes)
hold on
errorbar(meanResponseTimes,stdResponseTimes)
title('Response Time (s)')
set(gca,'XTickLabel',{'black','long','short','spot'})

%% rewarded trials
figure
bar(numRewards)
hold on
%errorbar(meanResponseTimes,stdResponseTimes)
title('# rewards')
set(gca,'XTickLabel',{'black','long','short','spot'})