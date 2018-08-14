function [corrs] = Correlation (FileSearch, OutPath)


opengl software
% OutPath = '..\Exp1\';

expSig = FileSearch;

norma = 1;
cellNumbers = [30 63 384 20 20];
areaCode = [0 1 4 7 8];

StimCount = 16;
StimSpace = 625 ;% tstop / StimCount;
tstop = 10000;
reference =6;
corrEC = [];
corrCA3 = [];
corrDG = [];

%% EC
i = 1;
fileNames = dir([OutPath expSig 'SpikeTime' num2str(areaCode(i)) '.txt']);
fn = {fileNames.name};
for sname = fn
    SpikeTimes = importdata([OutPath sname{1}]);
    [hell, cor] = ParseTrials(StimCount, cellNumbers(i), tstop, SpikeTimes, reference, norma);
    corrEC = [corrEC; cor];
end


%% CA3
i = 2;
fileNames = dir([OutPath expSig 'SpikeTime' num2str(areaCode(i)) '.txt']);
fn = {fileNames.name};
for sname = fn
    SpikeTimes = importdata([OutPath sname{1}]);
    [hell, cor] = ParseTrials(StimCount, cellNumbers(i), tstop, SpikeTimes, reference, norma);
    corrCA3 = [corrCA3; cor];
    disp(sname)
end


i = 3;
fileNames = dir([OutPath expSig '*SpikeTime' num2str(areaCode(i)) '.txt']);
fn = {fileNames.name};
for sname = fn
    SpikeTimes = importdata([OutPath sname{1}]);
    [hell, cor] = ParseTrials(StimCount, cellNumbers(i), tstop, SpikeTimes, reference, norma);
    corrDG = [corrDG; cor];
end

%% plot
% subplot(yplots, xplots, 1)
mcorrEC = mean (corrEC(:,6:end), 1);
mcorrCA3 = mean (corrCA3(:,6:end), 1);
mcorrDG = mean (corrDG(:,6:end), 1);

stdcorrEC = std (corrEC(:,6:end), 1);
stdcorrCA3 = std (corrCA3(:,6:end)', 1);
stdcorrDG = std (corrDG(:,6:end), 1);

hold off;
ECfit  = plot (mcorrEC, 'r:', 'LineWidth', 1);
% ECfit  = boundedline(0:10, meanPer, stdPer, 'k--', 'alpha')
hold on;
% CA3fit = plot(mcorrCA3(6:end), 'b', 'LineWidth', 1);
CA3fit = boundedline(1:11, mcorrCA3, stdcorrCA3, 'r', 'alpha');
DGfit  = boundedline(1:11, mcorrDG, stdcorrDG, 'b--', 'alpha');

chil = get(gca, 'children');
set(gca, 'YTick'       , 0:.5:1);
set(gca, 'XTick'        , 1:1:11);
ylim([0 1]);
xlim([1 11]);

        box off;
legend([chil(5); chil(3); chil(1)], 'EC', 'CA3', 'DG', 'Location', 'SouthWest')
legend('boxoff')



    

end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%% Formatting %%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Labeling subplots xplots = 2; yplots = 2;
% subLabels = ['A' 'B'; 'B' 'N'; 'C' 'F'; 'G' 'H'];
% subLabels = subLabels';
% %                   Title               x          y
% subTexts ={'None'          'Patterns pairwise comparison'           'Correlation';
%            'None'          'Patterns pairwise comparison'           'Correlation';
%            'ACH 1'          'Frequency (Hz)' '(spk/sec)^2/Hz';
%            'None'          'Frequency (Hz)' 'None';
%            'ACH 1 OLM off'                   'Time (ms)'         'Population firing rate';
%            'None'                    'Frequency (Hz)'    'PSD [(spk/sec)^2/Hz]';
%            'ACH 1 AC off'                   'Time (ms)'         'Population firing rate';
%            'None'   'Time lag (ms)'              'Autocorrelation [(spk/sec)^2]'};
%         
% % Adding titles and x y labels
% k = 1;
% for yi = 1:yplots
%     for xi = 1:xplots
%         disp(['xi = ' num2str(xi) ' yi = ' num2str(yi)])
%         if (xi > size(subLabels, 2) || yi > size(subLabels, 1) || k > size(subTexts, 1))
%             break;
%         end
%         hsubplots(k) = subplot(yplots, xplots, k);
%         
%         if (strcmp(subLabels(yi, xi), 'N'))
%         hsubLabels(k) = text(-0.22,1.17,'','Units', 'Normalized', 'VerticalAlignment', 'Top');
%         else
%         hsubLabels(k) = text(-0.142,1.07,subLabels(yi, xi),'Units', 'Normalized', 'VerticalAlignment', 'Top');
%         end 
%         
%         if ( strcmp(subTexts{k, 1} , 'None') )
%             hTitles(k) = title('');
%         else
%             hTitles(k) = title(subTexts{k, 1});
%         end
%         if ( strcmp(subTexts{k, 2} , 'None') )
%             hxLabels(k) = xlabel('');
%         else
%               hxLabels(k) = xlabel(subTexts{k, 2});
%         end
%         
%         if ( strcmp(subTexts{k, 3} , 'None') )
%             hyLabels(k) = ylabel('');
%         else    
%             hyLabels(k) = ylabel(subTexts{k, 3});
%         end
%               k = k+1;
%     end
% end
% 
% 
% % Legend
% 
% 
% % Other Labeling goes here
% 
% 
% % Formatting lines
%     % Line width should be from 1.5 to 2
% 
% chil = get(hsubplots(1), 'children');
% set (chil(2), ...
%     'Color'         , [0.2 0.2 0.9] , ...
%         'LineStyle'     , '--'          , ...
%     'LineWidth'     , 1.5             );
% 
% set (chil(4), ...
%     'Color'         , [0.9 0.2 0.2 ] , ...
%     'LineWidth'     , 1.5             );
% set (chil(6), ...
%     'Color'         , [0.2 0.2 0.2] , ...
%     'LineWidth'     , 1             );
% 
%     axes(hsubplots(1));
% chil = get(hsubplots(2), 'children');
% set (chil(2), ...
%     'Color'         , [0.2 0.9 0.2] , ...
%         'LineStyle'     , '--'          , ...
%     'LineWidth'     , 1.5             );
% 
% set (chil(4), ...
%     'Color'         , [0.9 0.2 0.2] , ...
%     'LineWidth'     , 1.5             );
% set (chil(6), ...
%     'Color'         , [0.2 0.2 0.2] , ...
%     'LineWidth'     , 1             );
% 
%   
% 
%     axes(hsubplots(2));
% set(gca, 'YTick'       , 0:.5:1);
% set(gca, 'XTick'        , 1:1:11);
% ylim([0 1]);
% xlim([1 11]);
% 
%         box off;
%  legend([chil(6); chil(4); chil(2)], 'EC', 'CA3 low ACH', 'CA3 high ACH', 'Location', 'SouthWest')
% 
% legend boxoff
% % set( chil(end), ...
% %       'LineStyle'       , '-.'      , ...
% %       'Marker'          , '.'        , ...
% %     'Color'         , [0 0.5 0]);
% % 
% % chil = get(hsubplots(3), 'children');
% %
% 
% % chil = get(hsubplots(4), 'children');
% 
% 
% 
%     
% %%%%%%%%%%%%%%%%%%%%%%
% % Formatting text    %
% %%%%%%%%%%%%%%%%%%%%%%
%     
%         set( [hsubplots]                    , ...
%         'FontName'   , 'Helvetica' );
%         set([hTitles, hxLabels, hyLabels], ...
%                 'FontName'   , 'AvantGarde');
%     % Labels  
%         set([ hyLabels, hxLabels]  , ...
%             'FontSize'   , 10          );
% 
%     % Titles
%         set( hTitles                   , ...
%             'FontSize'   , 10           );
%         
%         set( hsubLabels                    , ...
%             'FontSize'   , 12          , ...
%             'FontWeight' , 'bold'      );
% 
%     % Smaller
%         set([hsubplots]             , ...  % Legend goes here.
%             'FontSize'   , 8           );
% 
% % Other formatting
% 
% 
% 
% 
% %     axes(hsubplots(3));
% % %     set(gca, 'YTick'       , 0:10:40);
% % %     xlim([0 3000])
% %     box off
% %     axes(hsubplots(4));
% % %     set(gca, 'YTick'       , 0:100000:6000000);
% %     box off
% %     
% 
% % General tweaks
% % General tweaks
% 
% 
% %          'TickLength'  , [.02 .02] , ... 
% 
% set(hsubplots, ...
%       'TickDir'     , 'out'     , ...
% 'XMinorTick'  , 'off'      , ...
%   'YMinorTick'  , 'off'      , ...
%   'YGrid'       , 'off'      , ...
%   'XColor'      , [.3 .3 .3], ...
%   'YColor'      , [.3 .3 .3], ...
%   'LineWidth'   , 1         );
% 
% %   'YTick'       , 0:500:2500, ...
% %'Box'         , 'off'     , ...
% % opengl software
% % 
% set(hsubplots(1), 'Position', [0.1656    0.5838    0.7617    0.3412])
% set(hsubplots(2), 'Position', [0.1656   0.1100    0.7617    0.3412])
% %/