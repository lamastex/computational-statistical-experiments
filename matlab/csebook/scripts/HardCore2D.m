% simulation of Glauber dynamics for the hardcore model on 
% 2D regular torus grid 
clf; %clear; clc; % clear current settings
Seed=347632321; rand('twister',Seed); % set seed for PRNG
MaxSteps=1000000; % number of time steps to simulate
DisplayStepSize=10000; % display interval
Steps=0; % iniitalize time-step to 0
StepsM=1; % index for movie frame
Rows=100; % number of rows
Cols=100; % number of columns
CC = zeros(Rows,Cols,'int8'); %initialize all sites to be vacant
Delta=[-1,0,+1]; % neighbourhood of indices along one coordinate
Avg1s=0.0;%initialise the Average Fraction of occupied sites
while(Steps <= MaxSteps)
    % find a random site with 0 for possible swap
    I=ceil(Rows*rand); J=ceil(Cols*rand);
    % Get the Nbhd of CC(I,J)
    RowNbhd = mod((I-1)+Delta,Rows)+1;
    ColNbhd = mod((J-1)+Delta,Cols)+1;
    Nbhd=CC(RowNbhd, ColNbhd);
    To1Is=find(Nbhd); % find the 1s in Nbhd of CC(I,J)
    Num1s=length(To1Is); % total number of 1s in Nbhd
    if(Num1s > 0)
        CC(I,J)=0; % set site to be vacant
    elseif(rand < 0.5)
        CC(I,J)=1; % set site to be occupied
    else
        CC(I,J)=0; % set site to be vacant 
    end
    Steps=Steps+1; % increment time step
    Frac1s=sum(sum(CC))/(Rows*Cols); % fraction of occupied sites
    Avg1s = Avg1s + (Frac1s - Avg1s)/Steps; % online sample mean
    if(mod(Steps,DisplayStepSize)==0)
        A(StepsM)=getframe; % get the frame into A
        imagesc(CC)
        axis square
        StepsM=StepsM+1;
    end
end
Avg1s % print the sample mean of fraction of occupied sites
movie(A,5) % make a movie
