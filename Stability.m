function [profiles] = Stability(fileSearch, path)

% Stability.m:	this script analyzes the stability profile of the network given the Spiketimes of the neurons.  The script defines a function that is used as follows:
% Inputs:
% -	File searches: A cell array of 1 to 3 strings that are used to identify 1 to 3 sets of experiment files.  This algorithm uses the naming rule of output files employed by the neuron code.  The strings can use wildcard searches to capture all the files that need to 
% -	be included in the analysis.  See below for an example.
% -	OutputPath: 	a string containing the relative path where the output files can be found.  
% Example:
% -	Stability({'139full', '13*OLMoff'},'.\Outputs\') 
% Note that the second file search string uses a star instead of seed number to capture all files for this experiment which was run with multiple different seeds.
%   

 
    CA3mean = 0.5; CA3std = 0.78;

cellNumbers = [30 63 8 8 384 20 20];
areaCode = [0 1 2 3 4 7 8];
StimCount = 30;
tstop = 15000; bursts = 0:10;
RatioA1 = [0]; RatioA2 = [0]; RatioA3 = [0];
% OutPath = '..\..\Exp3\';
OutPath = path;

i = 1+1; % using the area codes as defined in the neuron code, but adding a plus one for compatibility with MATLAB

if length(fileSearch)>0
    
expSig = fileSearch{1};
EC = []; ECtn = [];
% load data From EC to represent the rate of increase in inputs
ECi = 0 +1; % using the area codes as defined in the neuron code, but adding a plus one for compatibility with MATLAB
fileNames = dir([OutPath expSig '*SpikeTime' num2str(areaCode(ECi)) '.txt']);
disp(['Loaded ' num2str(length(fileNames)) ' successfully'])
fn = {fileNames.name};
for sname = fn
    SpikeTimes = importdata([OutPath sname{1}]);
   [tn, z, active] = ParseZscores(StimCount, cellNumbers(ECi), tstop, SpikeTimes, 0.4, 0.1);
   stab = sum(active, 2)/cellNumbers(ECi); 
   EC = [EC; stab'];
   ECtn = [ECtn tn];
end


% Getting data from the first file search entry
RatioA1 = []; 
fileNames = dir([OutPath expSig 'SpikeTime' num2str(areaCode(i)) '.txt']);
fn = {fileNames.name};
for sname = fn
    SpikeTimes = importdata([OutPath sname{1}]);
   [tn, z, active] = ParseZscores(StimCount, cellNumbers(i), tstop, SpikeTimes, CA3mean , CA3std);
   stab = sum(active, 2)/cellNumbers(i); %Calculating the ratio between active neurons and the total number of neurons.
   RatioA1 = [RatioA1; stab'];
   
end

end % if >1


if length(fileSearch)>=2
 
expSig = fileSearch{2};
RatioA2=[];
fileNames = dir([OutPath expSig 'SpikeTime' num2str(areaCode(i)) '.txt']);
fn = {fileNames.name};
for sname = fn
    SpikeTimes = importdata([OutPath sname{1}]);
   [tn, z, active] = ParseZscores(StimCount, cellNumbers(i), tstop, SpikeTimes, CA3mean , CA3std);
   stab = sum(active, 2)/cellNumbers(i); 
   RatioA2 = [RatioA2; stab'];
end
end % if >2



if length(fileSearch)>=3
 
expSig = fileSearch{3};

RatioA3 = []; 
fileNames = dir([OutPath expSig 'SpikeTime' num2str(areaCode(i)) '.txt']);
fn = {fileNames.name};
for sname = fn
    SpikeTimes = importdata([OutPath sname{1}]);
   [tn, z, active] = ParseZscores(StimCount, cellNumbers(i), tstop, SpikeTimes, CA3mean , CA3std);
   stab = sum(active, 2)/cellNumbers(i); 
   RatioA3 = [RatioA3; stab'];
   
end
end % if>3

% Ploting the stability curve
mnEC = mean(EC, 1);
stEC = std(EC,1);
plot(mnEC,     'Color'         , [0.4 0.4 0.4] , ...
        'LineWidth',    1 ,...
        'LineStyle'     , '-'     );
hold on;

mnCA3low = mean(RatioA1, 1);
stCA3low = std(RatioA1,1);
boundedline(1:30, mnCA3low,stCA3low, 'r', 'alpha');

mnCA3med = mean(RatioA2, 1);
stCA3med = std(RatioA2,1);
boundedline(1:30, mnCA3med,stCA3med, 'g', 'alpha');

mnCA3high = mean(RatioA3, 1);
stCA3high = std(RatioA3,1);
boundedline(1:30, mnCA3high,stCA3high, 'b', 'alpha');

xlabel('Trial'); ylabel('Ratio Active');

profiles= struct;
profiles.ra1=RatioA1;
profiles.ra2=RatioA2;
profiles.ra3=RatioA3;


end
