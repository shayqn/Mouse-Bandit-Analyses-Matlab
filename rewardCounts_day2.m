
rewardcount = 0;
leftrewards = 0;
rightrewards = 0;

for i = 1:size(pokeHistory,1)
    if pokeHistory(i,3) ~= 0
        rewardcount = rewardcount + 1;
        if pokeHistory(i,3) == 2
            rightrewards = rightrewards + 1;
        elseif pokeHistory(i,3) == 3
            leftrewards = leftrewards + 1;
        else
            warning('Something is messed up');
        end
    end
end
