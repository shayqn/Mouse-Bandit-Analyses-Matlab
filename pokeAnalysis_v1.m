%% analyzing the pokes
%parameters:
iti = 2;
rewardWindow = 3;


%% parsing the pokes and the times into vectors from pokeHistory
numCols = length(pokeHistory);
pokeMatrix = zeros(3,numCols);

% let's get the port poked numbers into something more reasonable. Since
% the goal is the graph time vs port, with 0 = right, 1 = center, 2 = left
% (for visual simplicity), I'm going to make a variable portsPoked that
% contains exactly the information we need for the y part of the graph. 
portsPoked = zeros(1,numCols);
timePoked = zeros(1,numCols);
firstPoke = datevec(pokeHistory(1).timeStamp);
rewards = zeros(1,numCols);
centerPortNum = 0;

for i = 1:numCols;
    if strcmpi(pokeHistory(i).portPoked,'centerPort')
        portsPoked(i) = 1;
        centerPortNum = centerPortNum + 1; 
    elseif strcmpi(pokeHistory(i).portPoked,'leftPort')
        portsPoked(i) = 2;
    end
    % now make a timestamp vector
    timePoked(i) = etime(datevec(pokeHistory(i).timeStamp),firstPoke);
    if pokeHistory(i).REWARD == 1
        rewards(i) = 1;
    end
end

%% now we can plot. 
figure1 = figure;
axes1 = axes('Parent',figure1,'YTick',[0 1 2]);
ylim(axes1,[-0.2 2.2]);
box(axes1,'on');
hold(axes1,'on');
plot(timePoked(portsPoked==0),portsPoked(portsPoked==0),'Marker','o','LineStyle','none','Color',[1 0 1])
plot(timePoked(portsPoked==1),portsPoked(portsPoked==1),'Marker','o','LineStyle','none','Color',[0 0 0])
plot(timePoked(portsPoked==2),portsPoked(portsPoked==2),'Marker','o','LineStyle','none','Color',[0 1 0])
%datetick('x',13)

