% This M-file creates a vector array of all the dates of the data files.
% It also calculates the cost of the internet traffic per day for the university.
% It can be edited to produce the cost of each hit of internet traffic for
% a particular day.

% WARNING: THIS CODE TAKES 2-3 MINS OF RUNNING TIME TO CALCULATE RESULTS

% Wriiten by: Joshua Fenemore
% Last modified: 22/9/08

% Initialisers

dateList = [];
startDate = [20071203,20080100,20080200,20080300,20080400,20080500,20080600,20080700,20080800];
monthLength = [28,31,29,31,30,31,30,31,19];
counter = 1;
pathStart = 'U:\Class\STAT\STAT313\ProjectDataset\';
pathEnd = '-log.tab';
costArray = [];
hitCostArray = [];

% This section calculates a vector array of all the dates of all the data files

for i = 1:1:9
    for a = 1:1:(monthLength(i))
        dateList(counter) = startDate(i) + a;
        counter = counter + 1;
    end
end


for j = 1:1:(length(dateList)) % Loop for each date in dateList
    % For an array of costs for each hit for a particular day comment out
    % the above for loop (also the end statement at the end of this section
    dayCost = 0; % Initialiser
    % This section creates the file path name used to read in the data

    dateAsString = int2str(dateList(j)); % Convert each date to a string
    % For an array of costs for each hit change the j in the above line to
    % the element number of the date wanted from dateList
    filePath = strcat(pathStart,dateAsString,pathEnd); % Put all the strings together

    % Read in the data into an array fileData

    fileData = dlmread(filePath, '\t');

    % Figure out the size of the data. There will always be 9 columns of data. How many
    % hits/lines of data is calculated as dataLines

    fileSize = size(fileData);
    dataLines = fileSize(1);

    % This section calculates the universities cost for the day
    % Format is Row,Col for the matricies

    for a = 1:1:dataLines % Loop for each line of data in file
        hitCost = 0; % Initailiser
        mb = (fileData(a,9))/1048576; % Calculate how many bytes used in MB units
        if fileData(a,1) == 5;  % Is it NZ traffic?
            if fileData(a,5) < 7;   % Is it night-time traffic?
                hitCost = 0.125 * mb; % Cost for night, NZ 
            else
                hitCost = 0.25 * mb; % Cost for day, NZ
            end
        end
        if fileData(a,1) == 6; % Is it international traffic?
            if fileData(a,5) < 7; % Is it night-time traffic?
                hitCost = 1.25 * mb; % Cost for night, International
            else
                hitCost = 2.5 * mb; % Cost for day, International
            end
        end
        %hitCostArray(a) = hitCost; % For an array of costs for each hit
        % for a particular day uncomment the above line
        dayCost = hitCost + dayCost; % Add on the hit cost to the days total cost so far
    end
    %hitCostArray % For an array of costs for each hit
    % for a particular day uncomment the above line
    costArray(j) = dayCost; % Store the days cost in the cost array
    % For an array of costs for each hit change the j in the above line to1
end

% A marker to show the start of the output of the m file
disp('start here')
costArray % Output all the cost's for all the days of data
% A marker to show the end of the output of the m file
disp('end here')