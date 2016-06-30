%% random poke generator

% parameters
totalTime = 2118.6; %in seconds
numPokes = 1633;
iti = 1;
rewardwindow = 10;

simtimePoked = randsample(21886,1633);
simtimePoked = simtimePoked./10;

simportsPoked = zeros(1,numPokes);
for i = 1:numPokes
    simportsPoked(i) = randi(3)-1;
end

% %% now we plot, in the same style as the real data
% figure1 = figure;
% axes1 = axes('Parent',figure1,'YTick',[0 1 2]);
% ylim(axes1,[-0.2 2.2]);
% box(axes1,'on');
% hold(axes1,'on');
% plot(simtimePoked(simportsPoked==0),simportsPoked(simportsPoked==0),'Marker','o','LineStyle','none','Color',[1 0 1])
% plot(simtimePoked(simportsPoked==1),simportsPoked(simportsPoked==1),'Marker','o','LineStyle','none','Color',[0 0 0])
% plot(simtimePoked(simportsPoked==2),simportsPoked(simportsPoked==2),'Marker','o','LineStyle','none','Color',[0 1 0])

%% calculate and plot rewards

%for each poke. is it a 1? if so, has enough time elaspsed? if so, look at
%the next poke. does it come within the correct period? if so, is it the
%left or right port? if yes, assign a reward at that time. 

k = 1;
rewardTimes = zeros(1,1);
for i = 1:numPokes-1
    if i == 1
    elseif simportsPoked(i) == 1
        if (simtimePoked(i) - simtimePoked(i-1)) > iti
            if (simtimePoked(i+1) - simtimePoked(i)) < rewardwindow
                if simportsPoked(i+1) ~= 1
                    rewardTimes(k) = simtimePoked(i+1);
                    k = k+1;
                end
            end
        end
    end
end
simrewardNum = length(rewardTimes);