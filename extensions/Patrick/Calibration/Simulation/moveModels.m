function [ robotCrashes ] = moveModels( realModel, model, actuation )
%MOVEMODELS Function to unify the movement of the model and the realModel.
%Emulates the function of moveRobot.
%   Returns a 1 (true) if the realModel has crashed.

[robotCrashes] = model.moveJ(realModel.J, actuation);
if(~robotCrashes)
    %realModel.moveJ(realModel.J,actuation);
    simulatePrecise(realModel,actuation);
end

end

