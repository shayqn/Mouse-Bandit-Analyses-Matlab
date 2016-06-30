function trials2 = plotTrials(trials)
%plotTrials takes 'trials' (as calculated in extractTrials) and plots each
%trial as a green dot (for correct) or black x (for incorrect) with y = 1
%(for left block trials) or y = 0 (for right block trials). 

% add a column to trials that labels the blocks.

rows = size(trials,1);
cols = size(trials,2);
trials2 = zeros(rows,cols+1);
trials2(:,1:cols) = trials;

trials2(trials(:,3) > 0.5,5) = trials(trials(:,3) > 0.5,2);
trials2(trials(:,3) < 0.5,5) = trials(trials(:,3) < 0.5,2) - 1;
trials2(trials2(:,5) == 0,5) = 2;

correctTrials = trials2(trials(:,2) == trials2(:,5),[1:2,5]);
incorrectTrials = trials2(trials(:,2) ~= trials2(:,5),[1:2,5]);

figure
plot(correctTrials(:,1),correctTrials(:,3),'.g');
hold on
plot(incorrectTrials(:,1),incorrectTrials(:,3),'.r');


