function [TrialNeurons, z, active] = ParseZscores (StimCount, neurons, tstop, SpikeTimes, meanFiringRate, meanSTD)
StimSpace = tstop/ StimCount;

    TrialNeurons= zeros(StimCount, neurons);
    for i = 1:size(SpikeTimes, 1)
        trialNo = ceil(SpikeTimes(i, 2) / StimSpace);
        neuronNo = SpikeTimes(i, 1);
        if (neuronNo < neurons)
            TrialNeurons(trialNo, neuronNo+1) =         TrialNeurons(trialNo, neuronNo+1) + 1;
        end

    end

% as opposed to mean and std, mean2 std2 calculate for all matrix values
mTN = mean2(TrialNeurons);
stdTN = std2(TrialNeurons);
% Because comparing neurons to all neurons in the exp does not work
% I had to use the baseline firing rate of 0.5Hz and 
mTN = meanFiringRate ; %0.5;
stdTN = meanSTD ;% 0.2;
z = ( TrialNeurons - mTN ) / stdTN;


for i = 1:size(z, 1)
    for j = 1:size(z,2)
        if z(i,j) > 2.58
        active(i,j) = 1;
        else
            active(i,j) = 0;
        end
    end
end


end