function z = myzscore(actualRewardNum,simRewardDist)

u = mean(simRewardDist);
sigma = std(simRewardDist);

z = (actualRewardNum - u)/sigma;
