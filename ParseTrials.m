function [TrialNeurons, cor] = ParseTrials (StimCount, neurons, tstop, SpikeTimes, compareTo, norma)
StimSpace = tstop/ StimCount;

    TrialNeurons= zeros(StimCount, neurons);
    for i = 1:size(SpikeTimes, 1)
        trialNo = ceil(SpikeTimes(i, 2) / StimSpace);
        neuronNo = SpikeTimes(i, 1);
        if (neuronNo < neurons)
            TrialNeurons(trialNo, neuronNo+1) =         TrialNeurons(trialNo, neuronNo+1) + 1;
        end

    end

%     TrialNeurons = norma(TrialNeurons);
   if (norma >0 )
    for n = 1:size(TrialNeurons, 1)
%         if (norm(TrialNeurons(n, :)) > 0)
            TrialNeurons(n, :) =     TrialNeurons(n, :)./ norm(    TrialNeurons(n, :));
%         else
%             TrialNeurons(n, :) = 0.01;
%         end
    end
   end
    cor = [];

    for t = 1:size(TrialNeurons, 1)
        cor(end+1) = dot(TrialNeurons(compareTo, :), TrialNeurons(t, :) );
    end

end

function drawSpikeTimes (SpikeTimes)
    plot(SpikeTimes(:,2), SpikeTimes(:,1), 'r+', 'MarkerSize', 3);
end


function [TrialNeurons, cor] = ParseTrialsCS (StimCount, neurons, tstop, SpikeTimes, compareTo)
StimSpace = tstop/ StimCount;

    TrialNeurons= zeros(StimCount, neurons);
    for i = 1:size(SpikeTimes, 1)
        trialNo = ceil(SpikeTimes(i, 2) / StimSpace);
        kosor = (SpikeTimes(i, 2) / StimSpace) - (trialNo -1);
        if (kosor < 0.5)
            neuronNo = SpikeTimes(i, 1);
            TrialNeurons(trialNo, neuronNo+1) =         TrialNeurons(trialNo, neuronNo+1) + 1;
    
        end
        
    end

    for n = 1:size(TrialNeurons, 1)

        TrialNeurons(n, :) =     TrialNeurons(n, :)./ norm(    TrialNeurons(n, :));
    end

    cor = [];

    for t = 1:size(TrialNeurons, 1)
        cor(end+1) = dot(TrialNeurons(compareTo, :), TrialNeurons(t, :) );
    end

end