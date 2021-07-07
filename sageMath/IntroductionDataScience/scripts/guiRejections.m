function varargout = guiRejections(varargin)
% GUIREJECTIONS M-file for guiRejections.fig
%      GUIREJECTIONS, by itself, creates a new GUIREJECTIONS or raises the existing
%      singleton*.
%
%      H = GUIREJECTIONS returns the handle to a new GUIREJECTIONS or the handle to
%      the existing singleton*.
%
%      GUIREJECTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIREJECTIONS.M with the given input arguments.
%
%      GUIREJECTIONS('Property','Value',...) creates a new GUIREJECTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiRejections_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiRejections_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% 

% Last Modified by GUIDE v2.5 14-Oct-2008 13:42:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiRejections_OpeningFcn, ...
                   'gui_OutputFcn',  @guiRejections_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiRejections is made visible.
function guiRejections_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiRejections (see VARARGIN)


%handle for pseudo-random number generator seed
handles.prng_seed=17420001;

%intialise the fundamental sampler
rand('twister', handles.prng_seed);

% set the number of steps in the step by step simulation
handles.MaxSteps = 9;

% handle for the level of information given to users
handles.infoLevel=3;    

% handle for number of samples needed
size_val = get(handles.SampleSize,'value');
size_list = get(handles.SampleSize,'string');
handles.samplesReqd = str2double(size_list{size_val});

% handles to keep track of numbers found and rejected
handles.sampleN=0;  
handles.rejectionN=0;   

% handle for index (in the pop up list) of the function to draw from 
handles.targetIndex = 1; 

% Update handles structure
guidata(hObject, handles);

%initialise for the default TargetText distribution
handles = targetChooser(hObject, handles);
        
%draw the disributions, unscaled
handles=drawDistributionsUnscaled(hObject, handles);

%set default postion for uniform
handles.uniformPos = get(handles.uniform,'position');

%set default postion for commentary
handles.CommentaryPos = get(handles.Commentary,'position');
        
% Update handles structure
guidata(hObject, handles);

str_Nsamples = int2str(handles.sampleN);
set(handles.Nsamples,'String',str_Nsamples);

str_Nrejections = int2str(handles.rejectionN);
set(handles.Nrejections,'String',str_Nrejections);

% set an indicator for having rescaled for a
handles.isRescaled = 0;

% set a counter for the steps
handles.stepCounter = 1;

% next button initially invisible
set(handles.Next,'visible','off');
set(handles.NextText,'visible','off');

% set a hightlight colour for boxes we want to draw attention to
handles.lookCol = [1,.7,.8];
% and to return to neutral colour
handles.whiteCol = [1,1,1];

% Choose default command line output for guiRejections
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% set the text boxes to blank and uniform axes to default
h = resetProp(hObject,handles);
  
 


% UIWAIT makes guiRejections wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiRejections_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function h=targetChooser(hObject, handles)
% chooses the functions according to choice in the gui
switch(handles.targetIndex)
    case 1
        handles = NormalTarget(hObject, handles);
    case 2
        handles = WavyTarget(hObject, handles);
end
h=handles;
    

function h=NormalTarget(hObject, handles)
% --- draws the TargetText and ProposalText plots for the first time
handles.Mu=0;
handles.SigmaSq=1.0;
handles.Fac = sqrt(2*pi)*sqrt(handles.SigmaSq);

handles.lambda=1;

handles.a = 1.3155; % the constant a

%set the initial edit box values
str_a = num2str(handles.a,'%.2f');
handles.str_a = str_a;
set(handles.const_a,'String',str_a)

%set handle for title for ProposalText function
handles.proposalTitle = 'g(x) is Laplace(1.0)';
handles.targetTitle = 'f(x) is Normal(1, 0)';

set(handles.TargetText, 'string', ['Target ' handles.targetTitle]);
set(handles.ProposalText, 'string', ['Proposal ' handles.proposalTitle]);

% give handles to functions
handles.proppdf=@(x)(handles.lambda/2)*exp(-handles.lambda*abs(x));
handles.targpdf=@(x)(1/handles.Fac)*exp((-(x-handles.Mu).^2)/(2*handles.SigmaSq));
handles.propgen=@(u)(-(1/handles.lambda)*sign(u-0.5) .* log(1-2*abs(u-0.5)));

% Create the data to plot.

% set upper and lower limits for X
handles.targetXlower = -5;
handles.targetXupper = 5;
% set upper limits for Y
handles.targetYupper = 0.6;

% for proposals
% choose some x values to plot f(x) against
handles.Xs=linspace(handles.targetXlower,handles.targetXupper,...
    (handles.targetXupper-handles.targetXlower)*50);

% calculate the pdfs
handles.fXsL1=handles.proppdf(handles.Xs);      % pdf for proposal
handles.fXsZ=handles.targpdf(handles.Xs);      % pdf for target

set(handles.uniform,'XLim',[-0.1 0.1],'YLim',[0 1]) %give uniform correct scaling
set(handles.uniform,'XTick',[]);    % no x tick labels
set(handles.uniform, 'YTick',[0 1]); % y tick labels at 0 and 1

% set line widths for ProposalText and TargetText plots
handles.propLine = 3;
handles.targLine = 3;

% Update handles structure
guidata(hObject, handles);

h=handles;  % return the updated handle structure




function h=WavyTarget(hObject, handles)
% --- draws the TargetText and ProposalText plots for the first time
% assumes that the fundamental sampler has already been set
handles.c=rand(1,4)*2.0+2.0; % store the c's in the array called c

handles.a = 20; % the constant a

%set the initial edit box values
str_a = num2str(handles.a,'%.2f');
handles.str_a = str_a;
set(handles.const_a,'String',str_a)

%set handle for title for ProposalText and TargetText function
handles.proposalTitle = 'g(x) is Uniform [-10, 10]';
handles.targetTitle = 'f(x) is MyWavy function';

set(handles.TargetText, 'string', ['Target ' handles.targetTitle]);
set(handles.ProposalText, 'string', ['Proposal ' handles.proposalTitle]);

% give handles to functions
handles.proppdf=@(x)(1/20);
handles.targpdf=@(x)(exp( -2 + cos( handles.c(1) * x + handles.c(2) * x .^2)...
    + sin( handles.c(3) * x + handles.c(4) * x .^2 )));
handles.propgen=@(u)(20.0*u-10);

% Create the data to plot.

% set upper and lower limits for X
handles.targetXlower = -10;
handles.targetXupper = 10;
% set upper limits for Y
handles.targetYupper = 1.05;

% for proposals
% choose some x values to plot f(x) against
handles.Xs=linspace(handles.targetXlower,handles.targetXupper,...
    (handles.targetXupper-handles.targetXlower)*100);

% calculate the pdfs
handles.fXsL1=handles.proppdf(handles.Xs);      % pdf for proposal
handles.fXsZ=handles.targpdf(handles.Xs);      % pdf for target

set(handles.uniform,'XLim',[-0.1 0.1],'YLim',[0 1]) %give uniform correct scaling
set(handles.uniform,'XTick',[]);    % no x tick labels
set(handles.uniform, 'YTick',[0 1]); % y tick labels at 0 and 1

% set line widths for ProposalText and TargetText plots
handles.propLine = 2;
handles.targLine = 0.5;

% Update handles structure
guidata(hObject, handles);

h=handles;  % return the updated handle structure


function h=drawDistributionsUnscaled(hObject, handles)
% Create plot of TargetText function and of the ProposalText with no scaling
axes(handles.target_func)
plot(handles.Xs, handles.fXsZ,'r','LineWidth',handles.targLine)
hold on
plot(handles.Xs, handles.fXsL1,':b','LineWidth',handles.propLine)
set(handles.target_func,'XLim',[handles.targetXlower handles.targetXupper],...
    'YLim',[0.0 handles.targetYupper])

hold off

box off
grid off

% Update handles structure
guidata(hObject, handles);

h=handles;

function h=drawDistributionsScaled(hObject, handles)
% Create plot of TargetText function and of the ProposalText with scaling
axes(handles.target_func)
hold off
plot(handles.Xs, handles.fXsZ,'r','LineWidth',handles.targLine)
hold on
plot(handles.Xs, handles.a*handles.fXsL1,':b','LineWidth',handles.propLine)
set(handles.target_func,'XLim',[handles.targetXlower handles.targetXupper],...
    'YLim',[0.0 handles.targetYupper])

hold off

box off
grid off

% Update handles structure
guidata(hObject, handles);

h=handles;



% --- Executes on selection change in SampleSize.
function SampleSize_Callback(hObject, eventdata, handles)
% hObject    handle to SampleSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% store the new sample size
size_val = get(hObject,'value');
size_list = get(hObject,'string');
handles.samplesReqd = str2double(size_list{size_val});

% Update handles structure
guidata(hObject, handles);

% clear the samples found so far
handles =resetSample(hObject, handles);

% Hints: contents = get(hObject,'String') returns SampleSize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SampleSize



% --- Executes during object creation, after setting all properties.
function SampleSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampleSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TargetName.
function TargetName_Callback(hObject, eventdata, handles)
% hObject    handle to TargetName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns TargetName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TargetName

% store the old TargetText index, for comparison
handles.oldTargetIndex = handles.targetIndex;
% get the new one
handles.targetIndex = get(hObject,'value');

% Update handles structure
guidata(hObject, handles);

% compare to see if there is a change
% only need to reset disributions if there is a change
if handles.oldTargetIndex ~= handles.targetIndex
    % there has been a change
    
    % reset the sample (this also resets the fundamental sampler)
    handles = resetSample(hObject, handles);
    % reset the distributions
    handles.isRescaled=0;
    handles=targetChooser(hObject, handles);
    % Update handles structure
    guidata(hObject, handles);
    %draw the disributions, unscaled
    handles=drawDistributionsUnscaled(hObject, handles);

else
    % no change
    m=msgbox('There has been no change in the target distribution: gui will not be reset','modal');
    uiwait(m); % wait for user to click okay 
end


% --- Executes during object creation, after setting all properties.
function TargetName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TargetName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%helper function to clear the sample found so far
function h=resetSample(hObject, handles)
% executes when there is a change in sample size or TargetText distribution
%intialise the fundamental sampler
rand('twister', handles.prng_seed); % reinitialise the fundamental sampler

handles.sampledata=[];

resetHistogram(hObject, handles);

handles.sampleN=0;  
handles.rejectionN=0;  
handles.NumToGenerate=0;

% Update handles structure
guidata(hObject, handles);

% clear the some of the text boxes, and reset the uniform axes 
handles=resetProp(hObject, handles);        

% set the background to white for all text boxs
set(handles.proposal,'BackgroundColor',handles.whiteCol);
set(handles.f_of_y,'BackgroundColor',handles.whiteCol);
set(handles.g_of_y,'BackgroundColor',handles.whiteCol);
set(handles.bound,'BackgroundColor',handles.whiteCol);
set(handles.uniform_u,'BackgroundColor',handles.whiteCol);
set(handles.is_accepted,'BackgroundColor',handles.whiteCol);  
set(handles.Nsamples,'BackgroundColor',handles.whiteCol);    
set(handles.Nrejections,'BackgroundColor',handles.whiteCol);    

%redraw the TargetText and ProposalText to clear the most recent proposals
handles = drawDistributionsScaled(hObject, handles);

str_Nrejections = int2str(handles.rejectionN);
set(handles.Nrejections,'String',str_Nrejections);
str_Nsamples = int2str(handles.sampleN);
set(handles.Nsamples,'String',str_Nsamples);

% Update handles structure
guidata(hObject, handles);

h=handles;



% --- Executes on button press in GenerateAll.
% Generates all the rest of the required samples
function GenerateAll_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check if we are part way through generating
if (handles.stepCounter>1) && (handles.stepCounter <= handles.MaxSteps)
    m=msgbox('Please finish generating this one first - use the Next button');
    uiwait(m);
    return % return and with no furter action
end
%only get down here if not part way through

% check if we have already done the whole sample
if handles.sampleN>=handles.samplesReqd
    m = msgbox('All the required samples have been done:  another set will be started','Modal');
    uiwait(m); % wait for user to press okay
    %reset the sample
    h=resetSample(hObject, handles);
end

%set a handle for the number to generate
handles.NumToGenerate = handles.samplesReqd-handles.sampleN;

% Update handles structure
guidata(hObject, handles);

%call the generator, passing over number to generate in handles struct 
handles = Generator(hObject, handles);

%--- end of generate all




% --- Executes on button press in Generate10.
function Generate10_Callback(hObject, eventdata, handles)
% hObject    handle to Generate10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check if we are part way through generating
if (handles.stepCounter>1) && (handles.stepCounter <= handles.MaxSteps)
    m=msgbox('Please finish generating this one first - use the Next button');
    uiwait(m);
    return % return with no further action
end
%only get down here if not part way through

% set a handle for the number requested
handles.numberRequested = 10;

% Update handles structure
guidata(hObject, handles);

% call the helper function
handles = GenerateSubsample (hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% end of generate 10


% --- Executes on button press in Generate100.
function Generate100_Callback(hObject, eventdata, handles)
% hObject    handle to Generate100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check if we are part way through generating
if (handles.stepCounter>1) && (handles.stepCounter <= handles.MaxSteps)
    m=msgbox('Please finish generating this one first - use the Next button');
    uiwait(m);
    return % return with no further action
end
%only get down here if not part way through

% set a handle for the number requested
handles.numberRequested = 100;

% Update handles structure
guidata(hObject, handles);

% call the helper function
handles = GenerateSubsample (hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


%--- end of generate 100



function h=GenerateSubsample(hObject, eventdata, handles)
% called to generate a block within the main sample        

if handles.sampleN>=handles.samplesReqd && handles.numberRequested <= handles.samplesReqd 
    % already have them all and number requested less than current required
    % sample size
    msg = ['You already have your full sample.  Now starting another sample'];
    m=msgbox(msg,'modal');
    uiwait(m);
    
    handles=resetSample(hObject, handles);
    % set number to generate
    handles.NumToGenerate = handles.numberRequested;
    % Update handles structure
    guidata(hObject, handles);

    %call the generator, passing over number to generate in handles struct 
    handles = Generator(hObject, handles);

    % Update handles structure
    guidata(hObject, handles);
    
elseif handles.sampleN>=handles.samplesReqd && handles.numberRequested > handles.samplesReqd 
    % already have them all and number requested more than current required
    % sample size
        
    msg = ('The number you have asked for is more than the current sample size required:  generating only the full sample');
    m=msgbox(msg, 'modal');
    uiwait(m);
    handles=resetSample(hObject, handles);
    
    % Update handles structure
    guidata(hObject, handles);
    
    %set a handle for the number to generate
    handles.NumToGenerate = handles.samplesReqd;
           
    % Update handles structure
    guidata(hObject, handles);
    
     %call the generator, passing over number to generate in handles struct 
     handles = Generator(hObject, handles);
    
% if we don't have them all but have less than requested number to do    
elseif (handles.sampleN>handles.samplesReqd-handles.numberRequested) && ...
        (handles.sampleN<handles.samplesReqd)
    str_numLeft = int2str(handles.samplesReqd-handles.sampleN);
    msg = strcat('Only', [' ' str_numLeft],' needed to complete sample: sample will be completed');
    m = msgbox(msg,'Modal');
    uiwait(m); % wait for user to press okay
     %set a handle for the number to generate
    handles.NumToGenerate = handles.samplesReqd-handles.sampleN;

    % Update handles structure
    guidata(hObject, handles);

    %call the generator, passing over number to generate in handles struct 
    handles = Generator(hObject, handles);
   
else

    %set a handle for the number to generate
    handles.NumToGenerate = handles.numberRequested;

    % Update handles structure
    guidata(hObject, handles);

    %call the generator, passing over number to generate in handles struct 
    handles = Generator(hObject, handles);
    
end

 
% Update handles structure
guidata(hObject, handles);

h=handles;

%--- end of generate sub sample




%helper function for generation, called by multiple generations functions
function h=Generator(hObject, handles) 

% clear the text boxes and reset the uniform axes
handles=resetProp(hObject, handles);        

% set background colour of is_accepted to white
set(handles.is_accepted,'BackgroundColor',handles.whiteCol);  
% set background colour of Nsamples to white
set(handles.Nsamples,'BackgroundColor',handles.whiteCol);    
% set background colour of Nrejections to white
set(handles.Nsamples,'BackgroundColor',handles.whiteCol);  

%redraw the TargetText and ProposalText to clear the most recent proposals
handles = drawDistributionsScaled(hObject, handles);

% check if we need to do the rescaling for a step
if handles.isRescaled==0
    %call the rescale function
    rescale(hObject, handles);
    pause(2);
    % reset background colours of a to white
    set(handles.const_a,'BackgroundColor',handles.whiteCol);
end

% store the number we have now
numStartWith = handles.sampleN;

wb = waitbar(0,'Please wait...');

%while we have not got all the samples we want to add
while handles.sampleN < numStartWith + handles.NumToGenerate
waitbar((handles.sampleN-numStartWith)/handles.NumToGenerate)
    % generate y an RV from the ProposalText function
    u1=rand;

    y=handles.propgen(u1); % y from proposal generating function
    gy = handles.proppdf(y);    % g(y), the proposal pdf at y

    fy = handles.targpdf(y); % f(y), the target pdf at y

    % get the bound
    bnd=fy/(handles.a*gy);
    
    % generate a uniform[0,1] rv u
    u=rand;

    % check if accepted
    if u <= bnd;

        % add to the data
        handles.sampleN=handles.sampleN+1;
        
        if handles.sampleN==1    % if this is the first sample
            handles.sampledata=[y];
        else
            handles.sampledata=[handles.sampledata,y];
        end

    else
        handles.rejectionN=handles.rejectionN+1;
    end
    
end % end the while loop

close(wb)

%show the final sample and rejections values
str_Nrejections = int2str(handles.rejectionN);
set(handles.Nrejections,'String',str_Nrejections);
str_Nsamples = int2str(handles.sampleN);
set(handles.Nsamples,'String',str_Nsamples);

handles.NumToGenerate = 0;
handles.numberRequested = 0;

% Update handles structure
guidata(hObject, handles);

%show the histogram with the final data
myHistogram(hObject, handles);

h=handles;

% ----- end of Generator




% --- Executes on button press in Generate1.
% Generates a single sample, using the already intialised fundamantal
% sampler
% Actual sampling is done using sub-functions for steps
function Generate1_Callback(hObject, eventdata, handles)
% hObject    handle to Generate1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check if we have already done the whole sample
if handles.sampleN>handles.samplesReqd
    m = msgbox('All the required samples have been done:  another set will be started','Modal');
    uiwait(m); % wait for user to press okay
    %reset the sample
    h=resetSample(hObject, handles);
end

% clear the text boxes and reset the uniform axes 
handles=resetProp(hObject, handles);        
        
% set background colour of is_accepted to white
set(handles.is_accepted,'BackgroundColor',handles.whiteCol);  
% set background colour of Nsamples to white
set(handles.Nsamples,'BackgroundColor',handles.whiteCol);    
% set background colour of Nrejections to white
set(handles.Nsamples,'BackgroundColor',handles.whiteCol);    

%reset the step counter
handles.stepCounter = 1;
 
%make the generate1 button and its text invisible;
set(handles.Generate1,'Visible','off');
set(handles.Generate1Text,'Visible','off');

%redraw the TargetText and ProposalText to clear the most recent proposals
handles = drawDistributionsScaled(hObject, handles);

% check if we need to do the rescaling for a step
if handles.isRescaled==0
    handles.stepCounter = 1;
else
    % next button visible
    set(handles.Next,'visible','on');
    set(handles.NextText,'visible','on');
    handles.stepCounter = 2;

end

% Update handles structure
guidata(hObject, handles);

%call the next step
nextStep(hObject, handles);




% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%call next step function
nextStep(hObject, handles)


% helper function to wrap text into the Commentary box
% incoming text to wrap must be in handles.msgString
function setCommentary(hObject, handles)
%wrap the text to fit inside the commentary
pos = handles.CommentaryPos; % the original position for commentary
pos(3) = pos(3)-10;
set(handles.Commentary,'position', pos);
% Update handles structure
guidata(hObject, handles);
msgCell=cellstr(handles.msgString);
[outstring,newpos] = textwrap(handles.Commentary, msgCell);
% adjust the current position if necessary given recommended
% position newpos from textwrap
pos(3) = max(newpos(3)+10, pos(3));
pos(4) = max(newpos(4), pos(4));
set(handles.Commentary,'string',outstring,'position',pos);
% Update handles structure
guidata(hObject, handles);




%helper function to clear the text boxes and reset the uniform axes
function h=resetProp(hObject, handles)

%set the initial edit box values
set(handles.proposal,'String',' ');
set(handles.f_of_y,'String',' ');
set(handles.g_of_y,'String',' ');
set(handles.bound,'String',' ');
set(handles.uniform_u,'String',' ');

set(handles.is_accepted,'String',' ');
set(handles.Commentary,'String',' ');

% set the uniform axes to default mode
set(handles.uniform,'Position',handles.uniformPos);  % reset the height of the uniform
axes(handles.uniform);
plot(0, 1.5,'*r'); %this won't be seen but setting it clears present u and bound
set(handles.uniform,'XLim',[-0.1 0.1],'YLim',[0 1]);
set(handles.uniform,'XTick',[]);    % no x tick labels
set(handles.uniform, 'YTick',[0 1]); % y tick labels at 0 and 1

% Update handles structure
guidata(hObject, handles);

h=handles;

%choose which step according to current state of step counter
%step counter is in handles.stepCounter
function nextStep(hObject,handles)

switch handles.stepCounter
    case 1
        Step1(hObject,handles);
    case 2
        Step2(hObject,handles);
    case 3
        Step3(hObject,handles);
    case 4
        Step4(hObject,handles);
    case 5
        Step5(hObject,handles);
    case 6
        Step6(hObject,handles);
    case 7
        Step7(hObject,handles);
    case 8
        Step8(hObject,handles);
    case 9
        Step9(hObject,handles);
    otherwise
        % nothing
end
        


% helper function for showing constant a
function h=rescale(hObject, handles)
%wrap the text to fit inside the commentary
% set background colour of a to pink
set(handles.const_a,'BackgroundColor',handles.lookCol);

msg = strcat('The target probability density function (pdf)',  [' ' handles.targetTitle],...
            '.  The  proposal pdf  ', [' ' handles.proposalTitle],...
            '.  We need a constant a so f(x) <= ag(x) for every x ',...
                ' that we are trying to simulate the target f(x) over',...
                '.  The constant a to ensure this in this case is ', [' ' handles.str_a]);

handles.msgString = msg;
% Update handles structure
guidata(hObject, handles);

setCommentary(hObject, handles);

if handles.a~=1
        % Create plot of TargetText function and of the ProposalText with scaling
	    handles = drawDistributionsScaled(hObject, handles);
end

handles.isRescaled=1;

% Update handles structure
guidata(hObject, handles);

h=handles;



% rescaling the Proposal function
function Step1(hObject, handles)
%call the rescale function
handles = rescale(hObject, handles);
% next button visible
set(handles.Next,'visible','on');
set(handles.NextText,'visible','on');

%increment step counter
handles.stepCounter = handles.stepCounter+1;

% Update handles structure
guidata(hObject, handles);



function Step2(hObject,handles)

% reset background colour of a to white
set(handles.const_a,'BackgroundColor',handles.whiteCol);
 
% generate y an RV from the ProposalText function
u1=rand;

y=handles.propgen(u1); % y from proposal generating function
str_y = num2str(y, '%.3f'); % convert to string

handles.y = y;

% show y in the proposals box
set(handles.proposal,'String',str_y);

% set background colour of ProposalText to look colour
set(handles.proposal,'BackgroundColor',handles.lookCol);

%set the message according to the infoLevel
switch handles.infoLevel
    case 1
        set(handles.Commentary,'string',' ');
    otherwise
        msg=strcat('The proposal is ',[' ' str_y]);
       %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
end

%increment step counter
handles.stepCounter = handles.stepCounter+1;
% Update handles structure
guidata(hObject, handles);


function Step3(hObject,handles)

gy = handles.proppdf(handles.y);    % g(y), the proposal pdf at y

% show g(y) in its box
str_gy=num2str(gy,'%.3f');
set(handles.g_of_y,'String',str_gy);

% set background colour of ProposalText to white
set(handles.proposal,'BackgroundColor',handles.whiteCol);
% set background colour of gy to pink
set(handles.g_of_y,'BackgroundColor',handles.lookCol);

handles.gy = gy;
handles.str_gy = [' ' str_gy];

%set the message and plot according to the infoLevel
switch handles.infoLevel
    case 3
        
        % plot it on the proposals function
        axes(handles.target_func)
        hold on
        plot(handles.y, handles.a*gy,'*g'); % plot an '*' at (y,ag(y))
        plot([handles.y,handles.y],[0,handles.a*gy],':r','LineWidth',2); % plot a red dotted line from (y,0) to (y,ag(y))
        plot([handles.targetXlower,handles.y],[handles.a*handles.gy,handles.a*handles.gy],':k'); % plot a black dotted line from (0,ag(y)) to (y,ag(y))
        hold off
        
        msg=['Here is the part of the proposal pdf that the proposal maps to'];
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);

    otherwise
        set(handles.Commentary,'string',' ');
end

%increment step counter
handles.stepCounter = handles.stepCounter+1;
% Update handles structure
guidata(hObject, handles);


function Step4(hObject,handles)    

fy = handles.targpdf(handles.y); % f(y), the target pdf at y

% show f(y)
str_fy=num2str(fy,'%.3f');
set(handles.f_of_y,'String',str_fy);
% set background colour of fy to pink
set(handles.f_of_y,'BackgroundColor',handles.lookCol);

handles.fy = fy;
handles.str_fy = [' ' str_fy];

%set the message and plot according to the infoLevel
switch handles.infoLevel
    case 3
        msg=['And here is the part of the target pdf that the proposal maps to'];
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
        %increment step counter by 1
        handles.stepCounter = handles.stepCounter+1;

    case 2
        
        % plot y on the proposals function
        axes(handles.target_func)
        hold on
        plot(handles.y, handles.a*handles.gy,'*g'); % plot an '*' at (y,ag(y))
        plot([handles.y,handles.y],[0,handles.a*handles.gy],':r','LineWidth',2); % plot a red dotted line from (y,0) to (y,ag(y))
        plot([handles.targetXlower,handles.y],[handles.a*handles.gy,handles.a*handles.gy],':k'); % plot a black dotted line from (0,ag(y)) to (y,ag(y))

        hold off
        
        msg=['Map the proposal y to the proposal and target pdfs'];
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
        %increment step counter by 2
        handles.stepCounter = handles.stepCounter+2;

    otherwise
        % plot y on the proposals function
        axes(handles.target_func)
        hold on
        plot(handles.y, handles.a*handles.gy,'*g'); % plot an '*' at (y,ag(y))
        plot([handles.y,handles.y],[0,handles.a*handles.gy],':r', 'LineWidth',2); % plot a red dotted line from (y,0) to (y,ag(y))
        plot([handles.targetXlower,handles.y],[handles.a*handles.gy,handles.a*handles.gy],':k'); % plot a black dotted line from (0,ag(y)) to (y,ag(y))

        hold off

        set(handles.Commentary,'string',' ');
        %increment step counter by 2
        handles.stepCounter = handles.stepCounter+2;
end

% plot y on the TargetText function
axes(handles.target_func)
hold on
plot(handles.y, fy,'*g'); % plot an '*' at (y,ag(y))
plot([handles.y,handles.y],[0,fy],'-g', 'LineWidth',2); % plot green solid line from (y,0) to (y,fy)
plot([handles.targetXlower,handles.y],[fy,fy],':k'); % plot a black dotted line from (0,fy) to (y,fy)
hold off


% Update handles structure
guidata(hObject, handles);


function Step5(hObject,handles)

% show bound = f(y)/(a*g(y))
bnd=handles.fy/(handles.a*handles.gy);
bnd = round(bnd*100)/100; % cut off decimals
str_bnd=num2str(bnd,'%.4f');
set(handles.bound,'String',str_bnd);

handles.bnd = bnd;
handles.str_bnd = [' ' str_bnd];

str_agy=num2str(handles.a*handles.gy,'%.4f');

% set background colour of fy and gy to white
set(handles.g_of_y,'BackgroundColor',handles.whiteCol);
set(handles.f_of_y,'BackgroundColor',handles.whiteCol);
% set background colour of bound to pink
set(handles.bound,'BackgroundColor',handles.lookCol);

%set the message according to the infoLevel
switch handles.infoLevel
    case 3
        msg=strcat('The proposal pdf at y, adjusted by a, has height ',[' ' str_agy], ...
        ' whereas the target pdf has height ',handles.str_fy, ...
        '.  The ratio of the two is f(y)/ag(y), which is ',[' ' str_bnd]);
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
end

%increment step counter
handles.stepCounter = handles.stepCounter+1;

% Update handles structure
guidata(hObject, handles);


function Step6(hObject,handles)

% show bound = f(y)/(a*g(y))
bnd=handles.fy/(handles.a*handles.gy);
bnd = round(bnd*100)/100; % cut off decimals
str_bnd=num2str(bnd,'%.4f');
set(handles.bound,'String',str_bnd);

handles.bnd = bnd;
handles.str_bnd = [' ' str_bnd];

str_agy=num2str(handles.a*handles.gy,'%.4f');

% set background colour of fy and gy to white
set(handles.g_of_y,'BackgroundColor',handles.whiteCol);
set(handles.f_of_y,'BackgroundColor',handles.whiteCol);
% set background colour of bound to pink
set(handles.bound,'BackgroundColor',handles.lookCol);

str_bndpercent=num2str(bnd*100,'%.2f');

switch handles.infoLevel
    case 3   
        msg = strcat(str_bnd, ' is therefore the bound for the rejection sampling.  We might eventually get lots of ',...
            ' proposals of this exact y, but we only want to accept ', [' ' str_bndpercent],...
            ' % of them to match the density of our target distribution');
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
        
        %increment step counter by 1
        handles.stepCounter = handles.stepCounter+1;
    case 2
        msg=strcat('ag(y) is ', [' ' str_agy], ...
            ' and f(y) is ', handles.str_fy, ...
            '.  The ratio of the two is f(y)/ag(y) = ',[' ' str_bnd],...
            '.  This is the bound for the rejection sampling.');
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
        
        %increment step counter by 2
        handles.stepCounter = handles.stepCounter+2;
    otherwise
        set(handles.Commentary,'string',' ');
        %increment step counter by 2
        handles.stepCounter = handles.stepCounter+2;
end

% Update handles structure
guidata(hObject, handles);


function Step7(hObject,handles)

%set the message according to the infoLevel
switch handles.infoLevel
    case 3
        msg=strcat('If we generate a uniform [0,1] ',...
            ' random variable u, then the probability of u being ',...
            ' at or below our bound of ', handles.str_bnd,' is ', handles.str_bnd, 'itself.  So we can decide ',...
            ' to accept y if this u happens to be below the bound.  With enough sampling ',...
            ' the proportion of proposals of this y that we would accept would be f(y)/ag(y), ',...
            ' which is what we are aiming for.');
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
    otherwise
        %no change
end

%increment step counter
handles.stepCounter = handles.stepCounter+1;

% Update handles structure
guidata(hObject, handles);


function Step8(hObject,handles)

% generate a uniform[0,1] rv u
u=rand;

handles.u = u;

% show the uniform 
str_u=num2str(u,'%.4f');
set(handles.uniform_u,'String',str_u);

set(handles.bound,'BackgroundColor',handles.whiteCol);
% set background colour of u to pink
set(handles.uniform_u,'BackgroundColor',handles.lookCol);

%store the current position for the uniform function
currentUniPos = get(handles.uniform,'Position');
% and for the TargetText
targetPos = get(handles.target_func,'Position');
%rescale height of the uniform according to ag(y) 
currentUniPos(4)=(targetPos(4)/handles.targetYupper)*handles.a*handles.gy;
% and give the new position to the uniform
set(handles.uniform,'Position',currentUniPos); 

% show the bound and u on the uniform axis
axes(handles.uniform);

plot([-0.1,0.1],[handles.bnd,handles.bnd],'-r','LineWidth',2) % plot the bound as a line
set(handles.uniform,'XLim',[-0.1 0.1],'YLim',[0 1])
hold on
if u>handles.bnd 
    plot(0, u,'pr');
else 
    plot(0, u,'p','Color',[0.0, 0.8, 0.2]);
end
hold off
set(handles.uniform,'XTick',[]);    % no x tick labels
set(handles.uniform, 'YTick',[0 1]); % y tick labels at 0 and 1

%set the message according to the infoLevel
switch handles.infoLevel
    case 3
        if u>handles.bnd 
             msg = strcat('The uniform u this time is ',[' ' str_u],...
                 '. This is above the bound, so on this occasion we reject this proposal.');
        else 
             msg = strcat('The uniform u this time is ',[' ' str_u],...
                '. This is below the bound, so on this occasion we accept this proposal.');
        end
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
    case 2
        if u>handles.bnd 
            msg = strcat('The uniform u = ',[' ' str_u],...
                '. Reject this proposal.');
        else 
            msg = strcat('The uniform u = ',[' ' str_u],...
                '. Accept this proposal.');
        end
        %wrap the text to fit inside the commentary
        handles.msgString = msg;
        guidata(hObject, handles);
        setCommentary(hObject, handles);
otherwise
        set(handles.Commentary,'string',' ');
end

%increment step counter
handles.stepCounter = handles.stepCounter+1;

% Update handles structure
guidata(hObject, handles);


function Step9(hObject,handles)

% set background colour of bound to white
set(handles.bound,'BackgroundColor',handles.whiteCol);
% set background colour of uniform to white
set(handles.uniform_u,'BackgroundColor',handles.whiteCol);


% show whether accepted
if handles.u<=handles.bnd
    
    % add to the data
    
    handles.sampleN=handles.sampleN+1;
    str_Nsamples = int2str(handles.sampleN);
    set(handles.Nsamples,'String',str_Nsamples);

    set(handles.is_accepted,'String','Yes');
    % set background colour of is_accepted to pink
    set(handles.is_accepted,'BackgroundColor',handles.lookCol);  
    % set background colour of Nsamples to pink
    set(handles.Nsamples,'BackgroundColor',handles.lookCol);    
    
    if handles.sampleN==1    % if this is the first sample
        handles.sampledata=[handles.y];
    else
        handles.sampledata=[handles.sampledata,handles.y];
    end

    % Update handles structure
    guidata(hObject, handles);
    
    myHistogram(hObject, handles)
    % Cs=-5:0.1:5;
    %Freq=hist(handles.sampledata,Cs);    % get the relative frequencies
    %axes(handles.sample_hist);
    % bar(Cs,Freq/handles.sampleN,'b');
    %set(handles.sample_hist,'XLim',[-5 5],'YLim',[0 1])
    %title('Relative frequency histogram for samples')
    %xlabel('x')
    %ylabel('relative frequency') 
        
else
    handles.rejectionN=handles.rejectionN+1;

    str_Nrejections = int2str(handles.rejectionN);
    set(handles.Nrejections,'String',str_Nrejections);
        % set background colour of Nsamples to pink
    set(handles.Nrejections,'BackgroundColor',handles.lookCol);    

end

% next button invisible
set(handles.Next,'visible','off');
set(handles.NextText,'visible','off');

%make the generate1 button and its text visible;
 set(handles.Generate1,'visible','On');
 set(handles.Generate1Text,'Visible','on');

%increment step counter
handles.stepCounter = handles.stepCounter+1;

% Update handles structure
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function proposal_func_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proposal_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate proposal_func




% ------------------------ functions for the boxes etc -------------------



% --- Executes during object creation, after setting all properties.
function proposal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proposal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function proposal_Callback(hObject, eventdata, handles)
% hObject    handle to proposal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of proposal as text
%        str2double(get(hObject,'String')) returns contents of proposal as a double


function const_a_Callback(hObject, eventdata, handles)
% hObject    handle to const_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of const_a as text
%        str2double(get(hObject,'String')) returns contents of const_a as a double


% --- Executes during object creation, after setting all properties.
function const_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_of_y_Callback(hObject, eventdata, handles)
% hObject    handle to f_of_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_of_y as text
%        str2double(get(hObject,'String')) returns contents of f_of_y as a double


% --- Executes during object creation, after setting all properties.
function f_of_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_of_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g_of_y_Callback(hObject, eventdata, handles)
% hObject    handle to g_of_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g_of_y as text
%        str2double(get(hObject,'String')) returns contents of g_of_y as a double


% --- Executes during object creation, after setting all properties.
function g_of_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g_of_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bound_Callback(hObject, eventdata, handles)
% hObject    handle to bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bound as text
%        str2double(get(hObject,'String')) returns contents of bound as a double


% --- Executes during object creation, after setting all properties.
function bound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function is_accepted_Callback(hObject, eventdata, handles)
% hObject    handle to is_accepted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of is_accepted as text
%        str2double(get(hObject,'String')) returns contents of is_accepted as a double


% --- Executes during object creation, after setting all properties.
function is_accepted_CreateFcn(hObject, eventdata, handles)
% hObject    handle to is_accepted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uniform_u_Callback(hObject, eventdata, handles)
% hObject    handle to uniform_u (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uniform_u as text
%        str2double(get(hObject,'String')) returns contents of uniform_u as a double


% --- Executes during object creation, after setting all properties.
function uniform_u_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uniform_u (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nsamples_Callback(hObject, eventdata, handles)
% hObject    handle to Nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nsamples as text
%        str2double(get(hObject,'String')) returns contents of Nsamples as a double


% --- Executes during object creation, after setting all properties.
function Nsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nrejections_Callback(hObject, eventdata, handles)
% hObject    handle to Nrejections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nrejections as text
%        str2double(get(hObject,'String')) returns contents of Nrejections as a double


% --- Executes during object creation, after setting all properties.
function Nrejections_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nrejections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function TitleBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TitleBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in informationLevel.
function informationLevel_Callback(hObject, eventdata, handles)
% hObject    handle to informationLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
case 'Lots of commentary' % User selects lots of commentary.
   handles.infoLevel = 3;
   set(handles.Commentary,'visible','on'); % commentary box visible
case 'Some commentary' % User selects some commentary.
   handles.infoLevel = 2; % commentary box visible
   set(handles.Commentary,'visible','on');
case 'No commentary' % User selects no commentary.
    handles.infoLevel = 1; % commentary box visible
    set(handles.Commentary,'visible','off');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function informationLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to informationLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Commentary_Callback(hObject, eventdata, handles)
% hObject    handle to Commentary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Commentary as text
%        str2double(get(hObject,'String')) returns contents of Commentary as a double


% --- Executes during object creation, after setting all properties.
function Commentary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Commentary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CloseButton.
% deletes the gui without asking for confirmation!
function CloseButton_Callback(hObject, eventdata, handles)
% hObject    handle to CloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%delete the gui without confirming!    
delete(handles.figure1)



% --- Changes the seed for the random number generator.
function Seed_Callback(hObject, eventdata, handles)
% hObject    handle to Seed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strSeed = int2str(handles.prng_seed); % convert the current seed to a string
prompt = ['The current seed is ', strSeed, '; please enter the new positive integer seed here:'];
dlg_title = 'Random number generator';
num_lines = 1;
def = {strSeed}; %default is the current seed
strNewSeed = inputdlg(prompt,dlg_title,num_lines,def); % get the user input as a cell array

newSeed = str2num(strNewSeed{1}); % convert the current seed to a string

% check the random number seed and abort set up if not positive integer
while (newSeed<0 || abs((newSeed-floor(newSeed))>0))
    
    prompt = ['Sorry, ', strNewSeed{1}, ' is not a positive integer seed.  Please try again'];
    dlg_title = 'Random number generator';
    num_lines = 1;
    def = {strSeed}; %default is the current seed before modification
    newSeed = inputdlg(prompt,dlg_title,num_lines,def); % get the user input
    end

%user input is valid
handles.prng_seed = newSeed;    %store the new seed as the prng_seed

%re-intialise the fundamental sampler
rand('twister', handles.prng_seed);

% Update handles structure
guidata(hObject, handles);


%reset the samplehistogram 
function resetHistogram(hObject, handles)
 %set the axes to the histogram
  axes(handles.sample_hist);  
  hold off
  plot(0,0)
  set(handles.sample_hist,'XLim',[handles.targetXlower handles.targetXupper],...
    'YLim',[0.0 handles.targetYupper]);
box off
% Update handles structure
guidata(hObject, handles);




% histogram.m
% Plots density histogram for data in X.
%
% Usage: histogram(X,plotdata,bounds,colour);
%
  function myHistogram(hObject, handles)
  %  an embedded version of Raaz's histogram function
    % Input: X = row vector of data,
    %        plotdata (binary) = plot data points?
    %        bounds = [lower bound , upper bound] for possible X values,
    %        colour (single-character string) = colour of histogram (default =
    %        'y' for yellow),
    %        bwmethod (optional, default = 2) = method of computing bin width:
    %                 0 = Scott's normal reference rule,
    %                 1 = Wand's one-stage rule,
    %                 2 = Wand's two-stage rule,
    %                 3 = manual,
    %        bw = manual bin width if bwmethod = 3.
    % Remark: Bin origin determined by centering the histogram, ie. so that 
    % left and right bin edges extend beyond min(X) and max(X) respectively 
    % by equal amounts.
    %
    % Reference: Wand M.P. (1997), "Data-based choice of histogram bin width", 
    % American Statistician 51, 59-64.
  
  X = handles.sampledata;
  plotdata = 0;
  bounds = [handles.targetXlower handles.targetXupper];
  colour = 'b';
  bwmethod = 2;
  
  n = length(X); Y = zeros(1,n);
  
  % check if 1 or less datapoints and return if so
  if n <=1 
      return
  end

% Determine bin width:

  n3 = n^(-1/3); n5 = n^(-.2); n7 = n^(-1/7);

  Xsort = sort(X); xiq = Xsort(ceil(.75 * n)) - Xsort(ceil(.25 * n));
  sdx = std(X);
  if xiq == 0, sigma = sdx;
  else,        sigma = min([sdx (xiq / 1.349)]); end

  if bwmethod == 0, bw = 3.4908 * sigma * n3;
  elseif bwmethod == 1
        g11 = 1.3041 * sigma * n5;
        bw  = 1.8171 * ((-psi(X,g11,2))^(-1/3)) * n3;
  elseif bwmethod == 2
        g22 = 1.2407 * sigma * n7;
        g21 = 0.9558 * ((psi(X,g22,4))^(-.2)) * n5;
        bw  = 1.8171 * ((-psi(X,g21,2))^(-1/3)) * n3;
  end

% Determine bin origin:

  xmin = min(X); xmax = max(X);
  xrange = max(X) - xmin;
  nbin = ceil(xrange / bw);
  xoffset = (nbin * bw - xrange) / 2;
  bbeg = max(bounds(1),xmin - xoffset); bend = min(bounds(2),xmax + xoffset);
  bw = (bend - bbeg) / nbin;
  BE = bbeg + bw * [0:nbin];

% Count frequencies:

  for i = 1:nbin, P(i) = sum(X >= BE(i) & X < BE(i+1)); end
  P = P / (n * bw);

% Plot histogram:

  YY = [0 1 1 0]' * P; YY = YY(:);
  XX = [1 1 0 0]' * BE(1:nbin) + [0 0 1 1]' * BE(2:(nbin+1)); XX = XX(:);

  %set the axes to the histogram
  axes(handles.sample_hist);  
  
  if plotdata
     plot(XX,YY,colour,X,Y,[colour '.'])
  else
     plot(XX,YY,colour)
  end
  box off
 %xlabel('support'), ylabel('density')
    set(handles.sample_hist,'XLim',[handles.targetXlower handles.targetXupper])
% Update handles structure
guidata(hObject, handles);

  
% Function: psi
% Required by histogram.m, kernel.m, sj91.m
%
% Reference: Wand M.P. (1997), "Data-based choice of histogram bin width", 
% American Statistician 51, 59-64: Equations (2.2), (4.1)-(4.4).

  function p = psi(X,g,r)

  n = length(X); c = (n^(-2)) * (g^(-r-1));

  if n < 1000
  
     In = ones(1,n);

     XX = X' * In - In' * X; XX = XX(:) / g; XX2 = XX .* XX;
     Phi = gaussian(XX,1);
  
     if     r == 2
         p = c * (XX2 - 1)' * Phi;
     elseif r == 4
         XX4 = XX2 .* XX2;
         p = c * (XX4 - 6 * XX2 + 3)' * Phi;
     elseif r == 6
         XX4 = XX2 .* XX2; XX6 = XX4 .* XX2;
         p = c * (XX6 - 15 * XX4 + 45 * XX2 - 15)' * Phi;
     else
         disp('Error: Input r for Function PSI must be 2, 4 or 6.'), return
     end
     
  else
  
     xmin = min(X); m = 500; d = (max(X) - xmin) / (m - 1);
     Im = ones(1,m); J = [1:m]; X = X - xmin; On = zeros(1,n);

     for j = 1:m, C(j) = sum(max([(1 - abs((X / d) - j + 1));On])); end

     CC = C' * C;
     JJ = J' * Im - Im' * J; JJ = d * JJ(:) / g; JJ2 = JJ .* JJ;
     CPhi = CC(:) .* gaussian(JJ,1);
  
     if     r == 2
         p = c * (JJ2 - 1)' * CPhi;
     elseif r == 4
         JJ4 = JJ2 .* JJ2;
         p = c * (JJ4 - 6 * JJ2 + 3)' * CPhi;
     elseif r == 6
         JJ4 = JJ2 .* JJ2; JJ6 = JJ4 .* JJ2;
         p = c * (JJ6 - 15 * JJ4 + 45 * JJ2 - 15)' * CPhi;
     else
         disp('Error: Input r for Function PSI must be 2, 4 or 6.'), return
     end
     
  end
  
% Function: gaussian
% Gaussian probability density function.
% Generates normal probability density values corresponding to X.
% Inputs: X = Row vector of support points for which normal density values
%             are required,
%         S = Row vector of standard deviations.
% Output: NPD = Row vector of normal probability density values.

  function NPD = gaussian(X,S)
  
  NPD = exp(-(X .* X) ./ (2 * S .* S)) ./ (sqrt(2 * pi) * S);

  


