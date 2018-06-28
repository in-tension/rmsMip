
well = "B02";
condition = "PI-103 10";
temp = load('Cells.mat');
Cells = temp.Cells;

fs=[];


blu =   [0.00,0.45,0.75];
ora =   [0.85,0.33,0.10];
yel =   [0.93,0.69,0.13];
purp =  [0.49,0.18,0.56];
gree =  [0.47,0.67,0.19];
lblu =  [0.30,0.75,0.93];
red =   [0.64,0.08,0.18];

myColors = [blu;ora;yel;gree];



tIntervals = zeros(size(Cells,2),1);
for i = 1:size(tIntervals)
    tIntervals(i) = i * (1.0/6.0);
end

AllSegs = vertcat(Cells{:});
AllTracks = [AllSegs.Tid];

Tracks = unique(AllTracks);
counts = hist(AllTracks,Tracks);
Tracks = Tracks(counts>20);


colCount = 5;

Mat = cell(length(Cells)+colCount,colCount*max(length(Tracks),1));



hold on
plotCount = 2;
seriesCount = 1;
laeout = [4 3];

temp = figure('Name',condition);
fs = [fs,temp];
title(condition)
subplot(laeout(1),laeout(2),1)

            
for i = 1:length(Tracks)
    try
        
        Mat(1,(i-1)*colCount+1) = num2cell(Tracks(i));

        Tid = Tracks(i);

        cells = [AllSegs([AllSegs.Tid] == Tid)];

        %% Collect Size Stats
        Areas = [cells.Area]; %* ResolutionXYZ(1)*ResolutionXYZ(2);

        MeanSize = mean(Areas);

        %% Get Covariance
        HullsCR = {cells.PixelList};
        Hullscov = cellfun(@cov, HullsCR,'UniformOutput', false);
        HullCov = cellfun(@(x) min(x(1,1),x(2,2)) / max(x(1,1),x(2,2)),Hullscov)';

        %% Collect Movement Stats
        HullPos = vertcat(cells.Centroid);
        Times = [cells.time];
        [Times, I] = sort(Times);
        HullPos = HullPos(I,:);

        DeltaPos = [0,0; diff(HullPos,1,1)];
        Veloc = sqrt(DeltaPos(:,1).^2+DeltaPos(:,2).^2);
        MeanVoc = mean(Veloc);
        
        
        
        if seriesCount == 4 
            subplot(laeout(1),laeout(2),plotCount)
            myLine = refline(0,5);
            myLine.Color = [0 0 0];
            title(well + ": " + Tracks(i))
            ylim([0,50])
            
            seriesCount = 0;
            if plotCount == laeout(1)*laeout(2)
                plotCount = 1;
                temp = figure('Name',condition);
                fs = [fs,temp];
                title(condition)

            else
                plotCount = plotCount + 1;
            end
        else
            seriesCount = seriesCount + 1;
        end
        
        tempIntervals = tIntervals(1:size(Veloc,1));
        hold on
        t = scatter(tempIntervals, Veloc, 'filled','MarkerFaceColor',myColors(seriesCount,:))
        title(well + ": " + Tracks(i))
        ylim([0,50])
        
       
        
    catch e
        
        % added because sometimes index exceeds matrix dimensions error
        % don't know what's causing it
        % it appears that for the same well it happens sometimes but not
        % always with what seems to be the same conditions
        disp("cell " + i + ", track " + Tracks(i))
        disp("exception: " + e.identifier)
        disp("except.message: " + e.message)
        continue

    end     

end
