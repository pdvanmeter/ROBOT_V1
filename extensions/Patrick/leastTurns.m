function [ best_actuation ] = leastTurns( starting_point, good_set )
%Returns a single set of actuations from a set of several
%   Returned set is the "closest" to starting_point

% Determine by summing and keeping an index of the best good_set
leastSum = 10000000000000;
index = 0;

% To be Continued
for n = 1:size(good_set)
    sum = 0;
    for i = 1:6
        sum = sum + abs(starting_point(i) - good_set(n,i));
    end
    if sum < leastSum
        leastSum = sum;
        index = n;
    end
end

% Return the "best" actuation
best_actuation = good_set(index,:);

end

