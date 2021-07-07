%% Load the data from the comma delimited text file 'NZ20110222earthquakes.csv' with 
%% the following column IDs 
%% CUSP_ID,LAT,LONG,NZMGE,NZMGN,ORI_YEAR,ORI_MONTH,ORI_DAY,ORI_HOUR,ORI_MINUTE,ORI_SECOND,MAG,DEPTH 
%% Using MATLAB?s dlmread command we can assign the data as a matrix to EQ; 
%% note that the option 1,0 to dlmread skips first row of column descriptors 
% 
% the variable EQall is about to be assigned the data as a matrix 
EQall = dlmread('NZ20110222earthquakes.csv', ',' , 1, 0); 
size(EQall) % report the dimensions or size of the matrix EQall 
%ans = 145 14 

EQall(any(isnan(EQall),2),:) = []; %Remove any rows containing NaNs from the matrix EQall 
% report the size of EQall and see if it is different from before we removed and NaN containing rows 
size(EQall) 
% output: ans = 145 14 
% remove locations outside Chch and assign it to a new variable called EQ 
% only keep earthquake hypocenter locations inside Chch
% only keep earthquakes with magnitude >3 
EQ = EQall(-43.75<EQall(:,2) & EQall(:,2)<-43.45 & 172.45<EQall(:,3) ...
                             & EQall(:,3)<172.9 & EQall(:,12)>3, :);  
% now report the size of the earthquakes in Christchurch in variable EQ 
size(EQ) 
% output: ans = 124 14 

% assign the four variables of interest
LatData=EQ(:,2); LonData=EQ(:,3); MagData=EQ(:,12); DepData=EQ(:,13);

% finally make a plot matrix of these 124 4-tuples as red points 
plotmatrix([LatData,LonData,MagData,DepData], 'r.'); 
