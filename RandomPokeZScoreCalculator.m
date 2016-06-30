%5 This script generates a distribution of simulated rewards based on the
%number of pokes in a specified length of time that a mouse did during a
%behavior sesion. Specifically, it randomely generates the same number of
%pokes in the same time period, then randomely assigns a port number (1, 2,
%or 3 for right, center, or left). Then it applies the constraints of the
%specific session (that is - time to get reward, required no poke period
%before trial start) to calculate how many rewards would have been recieved
%in response to the random pokes. It does this NumSims number of times to
%create a distribution of rewards. This historgram is plotted, and then the
%real number of rewards the mouse received is plotted on top. Finally, a
%z-score is calculated based on the mean and std of the simulated rewards. 

%% Required parameters for simulation
NumSims = 1000;
iti = 1;
rewardWindow = 3;
numPokes = length(timePoked);
sessionTime = timePoked(end);
blockSize = 10;

%% simulation
simrewardNums = zeros(1,NumSims);
simlefttrials = zeros(1,NumSims);
simrighttrials = zeros(1,NumSims);

for k = 1:NumSims %doing 1000 simulations
    [simrewardNums(k),simlefttrials(k),simrighttrials(k)] = rewardSimulator(sessionTime,numPokes,iti,rewardWindow, blockSize);
end
figure, 
h = histogram(simrewardNums);
h.FaceColor = [0 0 0];
xlabel('# of rewards')
ylabel('# of occurences')
legend('simulated # of rewards');
hold on

%% add the real reward to the histogram
realrewardNum = sum(rewards);
realrewardLine = line([realrewardNum realrewardNum],[0 max(histcounts(simrewardNums))],'Color',[1 0 1],'LineWidth',4);

%% calculate z-score

z = myzscore(realrewardNum,simrewardNums)
