function [numRewards, numRightTrials, numLeftTrials] = rewardSimulator(totalTime,numPokes,iti,rewardWindow, blockLength)
% simulates rewards by generating a random distribution of pokes based on
% the time and number of pokes the animal actually did.
% Note: April 25th, 2016 - I modififed the code to consider reward
% contingenies inverting after 'blockLength' number of trials.
% BUT the code still only assuming reward probabilities of 1 or 0. 

timeX10 = round(totalTime*1000);
simtimePoked = randsample(timeX10,numPokes);
simtimePoked = simtimePoked./1000;

simportsPoked = zeros(1,numPokes);
for i = 1:numPokes
    simportsPoked(i) = randi(3);
end


k = 1;
rewardTimes = zeros(1,1);
rewardPorts = zeros(1,1);
currRewards = 0;
currBlock = randi(2) + 1; % randomely start on left or right.
simtrials = zeros(1,numPokes);

for i = 1:numPokes-1
    
    %deal with the block switching.
    if currRewards >= blockLength && currBlock == 2
            currBlock = 3;
            currRewards = 0;
    elseif currRewards >= blockLength && currBlock == 3
            currBlock = 2;
            currRewards = 0;
    end
    
    if i == 1
    elseif simportsPoked(i) == 1
        if (simtimePoked(i) - simtimePoked(i-1)) > iti
            if (simtimePoked(i+1) - simtimePoked(i)) < rewardWindow
                %if we got this far, this is a correct trial decision poke.
                simtrials(i+1) = simportsPoked(i+1);
                if simportsPoked(i+1) == 2 && currBlock == 2
                        rewardTimes(k) = simtimePoked(i+1);
                        rewardPorts(k) = simportsPoked(i+1);
                        k = k+1;
                        currRewards = currRewards + 1;
                elseif simportsPoked(i+1) == 3 && currBlock == 3
                        rewardTimes(k) = simtimePoked(i+1);
                        rewardPorts(k) = simportsPoked(i+1);
                        k = k+1;
                        currRewards = currRewards + 1;         
                end
            end
        end
    end
end

%outputs
numRewards = k;
numRightTrials = sum(simtrials(simtrials == 2));
numLeftTrials = sum(simtrials(simtrials == 3));