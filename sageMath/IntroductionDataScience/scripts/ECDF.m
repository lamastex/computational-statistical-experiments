function [x1 y1] = ECDF(x, PlotFlag, LoxD, HixD)
% return the x1 and y1 values of empirical CDF  
% based on samples in array x of RV X  
% plot empirical CDF if PlotFlag is >= 1
%
% Call Syntax: [x1 y1] = ECDF(x, PlotFlag, LoxD,HixD);
% Input      : x = samples from a RV X (a vector), 
%              PlotFlag is a number controlling plot (Y/N, marker-size)
%              LoxD is a number by which the x-axis plot range is extended to the left
%              HixD is a number by which the x-aixs plot range is extended to the right
% Output     : [x1 y1] & empirical CDF Plot IF PlotFlag >= 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R=length(x);       % assume x is a vector and R = Number of samples in x
x1=zeros(1,R+2);
y1=zeros(1,R+2);        % initialize y to null vectors
for i=1:1:R        % loop to append to x and y axis values of plot
y1(i+1)=i/R;                   % append equi-increments of 1/R to y 
end                % end of for loop
x1(2:R+1)=sort(x);        % sorting the sample values
x1(1)=x1(2)-LoxD; x1(R+2)=x1(R+1)+HixD;   % padding x for emp CDF to start at min(x) and end at max(x)
y1(1)=0; y1(R+2)=1;         % padding y so emp CDF start at y=0 and end at y=1

% to make a ECDF plot for large number of points set the PlotFlag<1 and use
% MATLAB's plot function on the x and y values returned by ECDF -- stairs(x,y)
if PlotFlag >= 1       % Plot customized empirical CDF if PlotFlag >= 1
    %newplot;
    MSz=10/PlotFlag;   % set Markersize MSz for dots and circles in ECDF plot
                       % When PlotFlag is large MSz is small and the
                       % Markers effectively disappear in the ecdf plot
    R=length(x1);       % update R = Number of samples in x
        hold on            % hold plot for superimposing plots

    for i=1:1:R-1
        if(i>1 && i ~= R-1)  
            plot([x1(i),x1(i+1)],[y1(i),y1(i)],'k o -','MarkerSize',MSz)
        end
        if (i< R-1)
          plot(x1(i+1),y1(i+1),'k .','MarkerSize',2.5*MSz)
        end
        plot([x1(i),x1(i+1)],[y1(i),y1(i)],'k -')
        plot([x1(i+1),x1(i+1)],  [y1(i),y1(i+1)],'k -')

    end
    
    hold off;
end
