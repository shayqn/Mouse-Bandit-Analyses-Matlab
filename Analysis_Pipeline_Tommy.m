% Behavior Analysis Pipeline

%% Load in the data (specifically the stats data structure)
[fileName,pathName] = uigetfile('MultiSelect','on');

cd(pathName);
for i = 1:length(fileName)
    load(fileName{i});
end

%% Extracting Trials
ExtractingTrials_v1

%% Poke Analysis
pokeAnalysis_v1

%% Z score calculator
RandomPokeZScoreCalculator

%% 