% Behavior Analysis Pipeline

%% Load in the data (speficially the stats data structure)
[fileName,pathName] = uigetfile('MultiSelect','on');
cd(pathName);
for i = 1:length(fileName)
    load(fileName{i});
end

%% Extract Trials and plot
trials = extractTrials(stats,pokeHistory);
plotTrials(trials);

%% calculate left and right rewards

%determine which rows are left (2) or right (1) trials
LInds = trials(:,2) == 2;
RInds = trials(:,2) == 1;

%sum up the rewards in the left and right trials
rewards_L = sum(trials(LInds,4));
rewards_R = sum(trials(RInds,4));

%total number of rewards? calculate in two ways...
rewards_total1 = sum(trials(:,4));
rewards_total2 = rewards_L + rewards_R;

%% make blockID vector
numTrials = size(trials,1);
blockID = zeros(numTrials,1);
corrTrials = trials(:,3) >= 0.5;
blockID(trials(:,2) == 1) = 2;
blockID(trials(:,2) == 2) = 1;
blockID(corrTrials) = trials(corrTrials,2);
figure, plot(blockID,'.')

%% how many blocks
blockSwitch = diff(blockID);
blockSwitchInds = find(blockSwitch) + 1;
numBlocks = sum(abs(blockSwitch)) + 1;

%% errors to first reward
for i = blockSwitchInds
    
    
end



