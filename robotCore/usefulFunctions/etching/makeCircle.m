function realPoints=makeCircle(radius)

pathLength=2*pi*radius;
stepsize=.1;
steps=round(pathLength/stepsize);
theta=0;
for i=1:steps
    points(1,i)=cos(theta);
    points(2,i)=sin(theta);
    theta=theta +2*pi/steps;
end
realPoints=[points*radius; zeros(1,steps);ones(1,steps)];
% scatter3(points(1,:),points(2,:),zeros(1,steps))
% max(points(1,:))
% min(points(1,:))

end