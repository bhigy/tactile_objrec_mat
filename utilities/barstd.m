function barstd(hb, Y, STD)
    hold on;
    % For each set of bars, find the centers of the bars, and write error bars
    pause(0.1); %pause allows the figure to be created
    for ib = 1:numel(hb)
        %XData property is the tick labels/group centers; XOffset is the offset
        %of each distinct group
        xData = hb(ib).XData + hb(ib).XOffset;
        errorbar(xData,Y(:,ib),STD(:,ib),'k.')
    end
    hold off;
end