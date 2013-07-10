function [ reOrganized ] = orderPoints( points )
%ORDERPOINTS Rearranges the image points to sort by spatial distance.
%   Points will be ordered by 'nearness'.

% Create new matrix of points to organize
dpoints = points;
reOrganized = [];
reOrganized(:,1) = dpoints(:,1);
check = 1;
deb = [];

% Iteratively sort points by nearness
for k = 1:length(dpoints(1,:)) - 1
    dist = [];
    for i = 1:length(dpoints(1,:))
        dist(i) = norm(dpoints(:,check) - dpoints(:,i));
    end
    
    dist(check) = [];
    dpoints(:,check) = [];
    nextMoveLength = min(dist);
    check = 1;
    
    while (nextMoveLength ~= dist(check));
        check = check + 1;
    end
    
    deb(k) = check;
    reOrganized(:,k + 1) = dpoints(:,check);
end

end
