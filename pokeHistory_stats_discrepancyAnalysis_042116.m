%% Behavior Analysis for April 21st, 2016
%Test shit here. 

%% Analyze rewards by using both pokeHistory and stats separately
%(to make sure there aren't any discrepancies or bugs)
pokeAnalysis_v1
statsAnalysis_v1

%find any discrepancies
rewarddisc = abs(statsrewards-rewards);
discIndices = find(rewarddisc);
