function [ cumDists ] = pokeCumDist( pokeHistory )
%pokeCumDist takes 'pokeHistory' as its argument and returns a 3 col matrix
%where each column is the cumulative number of pokes in that noseport.

rightPort = 3;
centerPort = 1; 
leftPort = 2;
rewards = 0;
numPokes = length(pokeHistory(:,1));
cumDists = zeros(numPokes,4);

for i = 1:numPokes
    if pokeHistory(i,2) == rightPort
        cumDists(i,1) = max(cumDists(:,1)) + 1;
    elseif pokeHistory(i,2) == centerPort
        cumDists(i,2) = max(cumDists(:,2)) + 1;
    elseif pokeHistory(i,2) == leftPort
        cumDists(i,3) = max(cumDists(:,3)) + 1;
    end
    
    if pokeHistory(i,3) ~= 0
        cumDists(i,4) = max(cumDists(:,4)) + 1;
    end
end

