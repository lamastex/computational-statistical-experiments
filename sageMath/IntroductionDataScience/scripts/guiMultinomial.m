function varargout = guiMultinomial(varargin)
% GUIMULTINOMIAL M-file for guiMultinomial.fig
%      
%      guiMultinomial displays a GUI for visualising multinomial replications for
%      a 2-d (ie binomial) or 3-d multinomial distribution.
%
%      The following parameters are set using the GUI controls:
%           the dimension (2 or 3), ie parameter k for the multinomial (n,k)
%           the number of levels, ie parameter n for the multinomial (n,k)
%           the number of replications or samples to draw
%
%      guiMultinomial uses the following functions which must be present in
%      the same folder OR in the user's search path:
%           createData.m
%           createDeMoivreSampler.m
%           AddOutcomes.m
%           MultinomialOutcomes.m
%           MultinomialPdf.m
%           PdfMultOutcomes.m
%
%      GUIMULTINOMIAL, by itself, creates a new GUIMULTINOMIAL or raises the existing
%      singleton*.
%
%      H = GUIMULTINOMIAL returns the handle to a new GUIMULTINOMIAL or the handle to
%      the existing singleton*.
%
%      GUIMULTINOMIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIMULTINOMIAL.M with the given input arguments.
%
%      GUIMULTINOMIAL('Property','Value',...) creates a new GUIMULTINOMIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiMultinomial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiMultinomial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 05-Apr-2011 19:51:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiMultinomial_OpeningFcn, ...
                   'gui_OutputFcn',  @guiMultinomial_OutputFcn, ...
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


% --- Executes just before guiMultinomial is made visible.
function guiMultinomial_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiMultinomial (see VARARGIN)

% Choose default command line output for guiMultinomial
handles.output = hObject;


% ------------------ set up handles for gui parameters ----------------
%handle for pseudo-random number generator seed
handles.prng_seed=88;

%handle for dimensions
handles.dim = 2; % 2-dimensional by default

%handle for default viewing angle for 2-d view
handles.viewAngleDefaultX2 = 0; % for 2-dimensional default view
handles.viewAngleDefaultY2 = 90; % for 2-dimensional default view
handles.viewAngleMinX2 = 0; % min X for 2-dimensional default view
handles.viewAngleMaxX2 = 90; % max X for 2-dimensional default view
handles.viewAngleMinY2 = 0; % min Y for 2-dimensional default view
handles.viewAngleMaxY2 = 90; % max Y for 2-dimensional default view


%handle for default viewing angle for 3-d view
handles.viewAngleDefaultX3 = 30; % for 3-dimensional default view
handles.viewAngleDefaultY3 = 30; % for 3-dimensional default view
handles.viewAngleMinX3 = 10; % min X for 3-dimensional default view
handles.viewAngleMaxX3 = 85; % max X for 3-dimensional default view
handles.viewAngleMinY3 = 10; % min Y for 3-dimensional default view
handles.viewAngleMaxY3 = 85; % max Y for 3-dimensional default view

%handle for viewing angle
handles.viewAngleX = handles.viewAngleDefaultX2; % for 2-dimensional default view
handles.viewAngleY = handles.viewAngleDefaultY2; % for a 2-dimensional default view

% Update handles structure
guidata(hObject, handles);

% handle for levels
handles.trials = 10;

% handle for reps
handles.replications = 10;

%handle for what trial we are on (this not used but could be useful later?)
handles.tindex = 0;

%handle for what replication we are on
handles.rindex = 0;

%handle for if we are in the middle of some replications
handles.isModelLoaded = 0;

% show parameters on gui
set(handles.Dimension, 'value', 1);

%set the min and max view angles for view angle slider (visible in 3-d only)
%set(handles.ViewAngle, 'max', handles.viewAngleMaxX2);
%set(handles.ViewAngle, 'min', handles.viewAngleMinX2);
%set the min and max view angles for view up down slider (visible in 3-d only)
%set(handles.ViewUpDown, 'max', handles.viewAngleMaxY2);
%set(handles.ViewUpDown, 'min', handles.viewAngleMinY2);

%set(handles.ViewAngle, 'value', handles.viewAngleDefaultX2);
%set(handles.ViewUpDown, 'value', handles.viewAngleDefaultX2);

set(handles.Levels, 'value', 5);

set(handles.Reps, 'value', 1);


% Update handles structure
guidata(hObject, handles);

% show the default figure
h=setAxes(hObject, handles);
% UIWAIT makes guiMultinomial wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiMultinomial_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Reps_Callback(hObject, eventdata, handles)
% hObject    handle to Reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% update the handle for number of replications value
reps_val = get(hObject,'value');
reps_list = get(hObject,'string');
handles.replications = str2double(reps_list{reps_val});

% Update handles structure
guidata(hObject, handles);

h=setAxes(hObject, handles);  %update the model and the main plot




% --- Executes during object creation, after setting all properties.
function Reps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in Dimension.
function Dimension_Callback(hObject, eventdata, handles)
% hObject    handle to Dimension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% update the handle for dimensions value
handles.dim = 2; % 2-dimensional by default
if get(handles.Dimension,'Value')==2
   handles.dim = 3;  % 3-dimensional
end

% Update handles structure
guidata(hObject, handles);

h=setAxes(hObject, handles);  %update the model and the main plot

% Hints: contents = get(hObject,'String') returns Dimension contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Dimension




% --- Executes during object creation, after setting all properties.
function Dimension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dimension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Levels.
function Levels_Callback(hObject, eventdata, handles)
% hObject    handle to Levels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% update the handle for trials value
trial_val = get(hObject,'value');
trial_list = get(hObject,'string');
handles.trials = str2double(trial_list{trial_val});

% Update handles structure
guidata(hObject, handles);

h=setAxes(hObject, handles);  %update the model and the main plot

% Hints: contents = get(hObject,'String') returns Levels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Levels



% --- Executes during object creation, after setting all properties.
function Levels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Levels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function ViewAngle_Callback(hObject, eventdata, handles)
% hObject    handle to ViewAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newX=get(hObject,'Value'); % get the viewing angle

%set properties for the figure
axes(handles.dataplot);

%set the viewer position
view(newX, handles.viewAngleY);

handles.viewAngleX = newX;

% Update handles structure
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider




% --- Executes during object creation, after setting all properties.
function ViewAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ViewAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on slider movement.
function ViewUpDown_Callback(hObject, eventdata, handles)
% hObject    handle to ViewUpDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newY=get(hObject,'Value'); % get the up down viewing angle

%set properties for the figure
axes(handles.dataplot);

%set the viewer position
view(handles.viewAngleX,newY);

handles.viewAngleY = newY;

% Update handles structure
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ViewUpDown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ViewUpDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on button press in ChangeSeed.
function ChangeSeed_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeSeed (see GCBO)
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

% Update handles structure
guidata(hObject, handles);

h=setAxes(hObject, handles);  %update the model and the main plot



% --- Executes on button press in CloseButton.
function CloseButton_Callback(hObject, eventdata, handles)
% hObject    handle to CloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %delete the gui without confirming!    
	delete(handles.figure1)





% --- Executes on button press in DoOne.
function DoOne_Callback(hObject, eventdata, handles)
% hObject    handle to DoOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ~handles.isModelLoaded % if the model is not yet set up, set it up
    handles=setAxes(hObject, handles);  %update the model and the main plot
end

if handles.rindex > handles.replications % if we have already done all our reps, start again
    handles=setAxes(hObject, handles);  %update the model and the main plot
end

%Update handles structure
guidata(hObject, handles);

hold on; % be able to add to the plot

% set up a line object for the state of one replication,
% initialising at 0,0,0)
ball = line('Color', 'r', 'Marker', '.', 'Markersize', 25, ...
    'xdata', 0, 'ydata', 0, 'zdata', 0);

% set up a line object for the path of one replication, drawn in black
% with xor to add to colour already on plot
currentPath = line('Color', 'm', 'Marker', '.', 'Markersize', 10, 'erase', 'xor', ...
    'xdata', [], 'ydata', [], 'zdata', []);

r_index = handles.rindex;     % find which replication we are on

    for t_index = 1:handles.trials       % go through the trials for this replication
        %set up data for the ball (current state)
        set(ball, 'xdata', handles.model(t_index, r_index, 1), ...    % x data to first dimension for this rep and trial
                  'ydata', handles.model(t_index, r_index, 2), ...    % y data to second dimension for this rep and trial
                  'zdata', handles.model(t_index, r_index, 3));    % z data to third dimension for this rep and trial
        
        %set up data for the path it follows
        set(currentPath, 'xdata', [0; handles.model(1:t_index, r_index, 1)], ...    % x data from all trials up to t_index for this rep
                         'ydata', [0; handles.model(1:t_index, r_index, 2)], ...    % y data similarly
                         'zdata', [0; handles.model(1:t_index, r_index, 3)]);    % z data similarly
        %draw the ball and path
        drawnow;
        %pause drawing between trials so give movement effect
        pause(0.02);
       
    end % end trials loop

    % we should have now plotted the data and path for the replication
    % indexed by r_index
    
    % reset the ball and path
    set(ball, 'xdata', 0, 'ydata', 0, 'zdata', 0);
    set(currentPath, 'xdata', [], 'ydata', [], 'zdata', []);

    % draw the history path, which gives the track the ball took but in
    % a lighter colour than the current path was drawn in

    line('Marker', '.', 'markersize', 5, 'LineWidth', 0.25, 'Color', handles.historyCol,...
        'xdata', [0; handles.model(:,r_index,1)],... % all dimension 1 data in column r_index
        'ydata', [0; handles.model(:,r_index,2)],... % all dimension 2 data in column r_index
        'zdata', [0; handles.model(:,r_index,3)]);   % all dimension 3 data in this colum in column r_index
    
    %update how many balls have arrived in each 'bucket' after each replication
    % this data is stored in the buckets matrix and indexed by bx, by, bz
    bx=handles.model(handles.trials, r_index, 1) + 1;    % set up the indices to buckets according to where ball ended up
    by=handles.model(handles.trials, r_index, 2) + 1;    % need + 1 to ensure that 0 in that dimension indexes to a 
    bz=handles.model(handles.trials, r_index, 3) + 1;    % valid element in buckets (first in that dimension)

    % the if-else loop sets up a matrix of line objects, one for each
    % bucket that at least one ball lands in

    % line length is the relative frequency, ie number of balls in that
    % bucket divided by number of replications
    % but scaled by bucketInc (as for pdf)

    if handles.buckets(bx, by, bz)==0 % if there is no data there yet
        handles.buckets(bx, by, bz) = 1; % make that element 1
        % set up the line, using the indices to calculate length
        handles.lineBucket(bx,by,bz) = line('Marker', 'o', 'Markersize', 3, 'Color', 'b', ...
        'xdata', [bx-1;bx-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)], ... 
        'ydata', [by-1;by-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)], ...
        'zdata', [bz-1;bz-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)]);
    else % line is already set up
        handles.buckets(bx, by, bz) = handles.buckets(bx, by, bz) + 1; % make that element +1
        set(handles.lineBucket(bx,by,bz), ...
            'xdata', [bx-1;bx-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)], ... 
            'ydata', [by-1;by-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)], ...
            'zdata', [bz-1;bz-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)]);
    end
    
% end of dealing with this replication

hold off % take hold off 

% add one to the rep counter
handles.rindex = handles.rindex+1;

% Update handles structure
guidata(hObject, handles);

% ---- end --------------






% --- Executes on button press in DoAll.
function DoAll_Callback(hObject, eventdata, handles)
% hObject    handle to DoAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset model only if we have done all our replications
% this allows us to finish off a set of replications where we have done
% some one by one
  
if handles.rindex > handles.replications % if we have already done all our reps, start again
    handles=setAxes(hObject, handles);  %update the model and the main plot
end

% make the axes current
axes(handles.dataplot);

hold on; % be able to add to the plot

% set up a line object for the state of one replication,
% initialising at 0,0,0)
ball = line('Color', 'r', 'Marker', '.', 'Markersize', 25, ...
    'xdata', 0, 'ydata', 0, 'zdata', 0);

% set up a line object for the path of one replication, drawn in black
% with xor to add to colour already on plot
currentPath = line('Color', 'm', 'Marker', '.', 'Markersize', 10, 'erase', 'xor', ...
    'xdata', [], 'ydata', [], 'zdata', []);


for r_index = handles.rindex:handles.replications     % for each remaining replication in turn
    for t_index = 1:handles.trials       % go through the trials for this replication
        %set up data for the ball (current state)
        set(ball, 'xdata', handles.model(t_index, r_index, 1), ...    % x data to first dimension for this rep and trial
                  'ydata', handles.model(t_index, r_index, 2), ...    % y data to second dimension for this rep and trial
                  'zdata', handles.model(t_index, r_index, 3));    % z data to third dimension for this rep and trial
        
        %set up data for the path it follows
        set(currentPath, 'xdata', [0; handles.model(1:t_index, r_index, 1)], ...    % x data from all trials up to t_index for this rep
                         'ydata', [0; handles.model(1:t_index, r_index, 2)], ...    % y data similarly
                         'zdata', [0; handles.model(1:t_index, r_index, 3)]);    % z data similarly
        %draw the ball and path
        drawnow;
        
        % pause between trials only if the number of replications is <=100
        if handles.replications <= 100
            pause(0.02);
        end %end if
        
    end % end trials loop

    % we should have now plotted the data and path for the replication
    % indexed by r_index
    
    % reset the ball and path
    set(ball, 'xdata', 0, 'ydata', 0, 'zdata', 0);
    set(currentPath, 'xdata', [], 'ydata', [], 'zdata', []);

    % draw the history path, which gives the track the ball took but in
    % a lighter colour than the current path was drawn in

    line('Marker', '.', 'markersize', 5, 'LineWidth', 0.25, 'Color', handles.historyCol,...
        'xdata', [0; handles.model(:,r_index,1)],... % all dimension 1 data in column r_index
        'ydata', [0; handles.model(:,r_index,2)],... % all dimension 2 data in column r_index
        'zdata', [0; handles.model(:,r_index,3)]);   % all dimension 3 data in this colum in column r_index
    
    %update how many balls have arrived in each 'bucket' after each replication
    % this data is stored in the buckets matrix and indexed by bx, by, bz
    bx=handles.model(handles.trials, r_index, 1) + 1;    % set up the indices to buckets according to where ball ended up
    by=handles.model(handles.trials, r_index, 2) + 1;    % need + 1 to ensure that 0 in that dimension indexes to a 
    bz=handles.model(handles.trials, r_index, 3) + 1;    % valid element in buckets (first in that dimension)

    % the if-else loop sets up a matrix of line objects, one for each
    % bucket that at least one ball lands in
    
    % line length is the relative frequency, ie number of balls in that
    % bucket divided by number of replications
    % but scaled by bucketInc (as for pdf)
   
    if handles.buckets(bx, by, bz)==0 % if there is no data there yet
        handles.buckets(bx, by, bz) = 1; % make that element 1
       % set up the line, using the indeces to calculate length
       handles.lineBucket(bx,by,bz) = line('Marker', 'o', 'Markersize', 3, 'Color', 'b', ...
        'xdata', [bx-1;bx-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)], ... 
        'ydata', [by-1;by-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)], ...
        'zdata', [bz-1;bz-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)]);
    else % line is already set up
        handles.buckets(bx, by, bz) = handles.buckets(bx, by, bz) + 1; % make that element +1
        set(handles.lineBucket(bx,by,bz), ...
            'xdata', [bx-1;bx-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)], ... 
            'ydata', [by-1;by-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)], ...
            'zdata', [bz-1;bz-1 + (handles.buckets(bx, by, bz)* handles.bucketInc/handles.replications)]);
    end
    

end % end of loop through each replication

hold off % take hold off 

handles.rindex = handles.replications+1;

% Update handles structure
guidata(hObject, handles);

% ---------------------------------------------end ----------------------




function updatedHandles = setAxes(hObject, handles)
% function to set up or update the basic figure
% returns the updated handles after setting up the figure

% show a waitbar
% note - this waitbar does not move because it's hard to tell how long the
% model will take to reset
wb = waitbar(0, 'Please wait, setting model ...');

%handle for pseudo-random number generator setup
handles.prng=@()(rand('twister', handles.prng_seed));

% handle for dimension and then set up viewing angle
% and visibility of view slider according to dimension
handles.dim = 2; % 2-dimensional by default
%set the min and max view angles for view angle slider (visible in 3-d only)
set(handles.ViewAngle, 'Max', handles.viewAngleMaxX2);
set(handles.ViewAngle, 'Min', handles.viewAngleMinX2);
%set the min and max view angles for view up down slider (visible in 3-d only)
set(handles.ViewUpDown, 'max', handles.viewAngleMaxY2);
set(handles.ViewUpDown, 'min', handles.viewAngleMinY2);
handles.viewAngleX = handles.viewAngleDefaultX2;
handles.viewAngleY = handles.viewAngleDefaultY2;
set(handles.ViewAngle, 'value', handles.viewAngleDefaultX2); % slider position
set(handles.ViewUpDown, 'value', handles.viewAngleDefaultY2); % slider position
set(handles.ViewAngle,'visible', 'off');
set(handles.ViewAngleText1,'visible', 'off');
set(handles.ViewAngleText2,'visible', 'off');
set(handles.ViewAngleText3,'visible', 'off');
set(handles.ViewUpDown,'visible', 'off');
set(handles.ViewUpDownText2,'visible', 'off');
set(handles.ViewUpDownText3,'visible', 'off');

%change these default (for 2-d) settings if 3-d is chosen
if get(handles.Dimension,'Value')==2 % if the second in the list is chosen
    handles.dim = 3;  % 3-dimensional
    %set the min and max view angles for view angle slider (visible in 3-d only)
    set(handles.ViewAngle,'visible', 'on');
    set(handles.ViewUpDown,'visible', 'on');
    set(handles.ViewAngle, 'max', handles.viewAngleMaxX3);
    set(handles.ViewAngle, 'min', handles.viewAngleMinX3);
    %set the min and max view angles for view up down slider (visible in 3-d only)
    set(handles.ViewUpDown, 'max', handles.viewAngleMaxY3);
    set(handles.ViewUpDown, 'min', handles.viewAngleMinY3);
    handles.viewAngleX = handles.viewAngleDefaultX3;
    handles.viewAngleY = handles.viewAngleDefaultY3;
    set(handles.ViewAngle, 'value', handles.viewAngleDefaultX3); % slider position
    set(handles.ViewUpDown, 'value', handles.viewAngleDefaultY3); % slider position
    set(handles.ViewAngleText1,'visible', 'on');
    set(handles.ViewAngleText2,'visible', 'on');
    set(handles.ViewAngleText3,'visible', 'on');
    set(handles.ViewUpDownText2,'visible', 'on');
    set(handles.ViewUpDownText3,'visible', 'on');
end

% handle for levels
trial_val = get(handles.Levels,'value');
trial_list = get(handles.Levels,'string');
handles.trials = str2double(trial_list{trial_val});

% handle for number of replications
reps_val = get(handles.Reps,'value');
reps_list = get(handles.Reps,'string');
handles.replications = str2double(reps_list{reps_val});

%set up the sampler
handles.sampler = createDeMoivreSampler(handles.dim);

% Update handles structure
%guidata(hObject, handles);

%create the data and load the model data
% this is a 3 d array with rows as trials, columns as reps,
% and 3rd dimension as dimension of the multinomial (2 or 3 for this gui)
handles.model = createData(handles.trials, handles.replications, handles.dim, handles.sampler, handles.prng);

% Update handles structure
%guidata(hObject, handles);

% if model has less than 3 dimensions, pad with zeros
if (size(handles.model,3)<3)
    padding = zeros(size(handles.model,1),size(handles.model,2)); % create a matrix of zeros
    for x = (size(handles.model,3)+1):3 % for each missing dimension
        handles.model(:,:,x) = padding; % add padding
    end
end % end padding

% Update handles structure
%guidata(hObject, handles);

%set properties for the figure
axes(handles.dataplot);
cla;    % clear the axes

%set the viewer position and bucket increment 
% and (3-d only) the position shown on the view angle sliders
% the bucket increment is for showing how many results end up in a bucket
% this is the amount the length of the line extending from the bucket
% increases with each extra ball ending up there
% the bucket increment is simply chosen to be enough to show shape but not so
% much it goes out of the scale of the axes.
% this is applied to both pdf and relative frequencies and could be
% altered to accentuate or flatten the shape of the curve
switch handles.dim
    case 2
        view(handles.viewAngleDefaultX2,handles.viewAngleDefaultY2);

        % number of possible outcomes is (n+1)
         handles.bucketInc = handles.trials;
    case 3
        view(handles.viewAngleDefaultX3,handles.viewAngleDefaultY3);
        %set(handles.ViewAngle, 'value', handles.viewAngleDefaultX3); % slider position
        %set(handles.ViewUpDown, 'value', handles.viewAngleDefaultY3); % slider position
        
        % number of possible outcomes is (n+1)*(n+2)/2
       handles.bucketInc = ((handles.trials-1)*(handles.trials-1)/2);
        
end

tickinc = floor(handles.trials/10) + 1; % eg 1 for 1-10 trials, 2 for 11-20 trials etc
Ticks = 0:tickinc:handles.trials;  % tick labels 

%draw the simplex on the axis
simp_coord = handles.trials*eye(3); % 3x3 matrix identity matrix scaled by by number of trials
simp_col(1,1,1,1:3) = [.4 .4 .9]; % simplex colour
simp_edge = [1 1 1];    % edge colour white
simp_alpha = 0.1;   % transparency
axes(handles.dataplot);
patch(simp_coord(:,1),simp_coord(:,2),simp_coord(:,3), simp_col, 'EdgeColor', simp_edge, 'FaceAlpha', simp_alpha);
hold on


% this axis has DrawMode and NextPlot and axis colour set in the gui specs

% make the ticks what we want 
set(handles.dataplot,'XTick',Ticks);
set(handles.dataplot,'YTick',Ticks);
set(handles.dataplot,'ZTick',Ticks);

% Update handles structure
%guidata(hObject, handles);

% plot the pdf of the multinomial rescaled by trials * bucketInc
% for 3-d get MultinomialPdf function assuming theta = [1/3,1/3,1/3]
% for binomial use the same pdf functin, assuming theta = [1/2, 1/2]
outcomes = MultinomialOutcomes(handles.trials, handles.dim); % gets the sample space
pdfOutcomes = PdfMultOutcomes(outcomes); % gets a column vector of the PDFs for sample space

% and then rescale by the bucket increment
MultPDFScaled = pdfOutcomes*handles.bucketInc;

if handles.dim == 2 % 3-d model
    msize = min((15/handles.trials)*10,15); % adjust marker size according to trials if trials>10
    plot(outcomes(:,1)+MultPDFScaled,outcomes(:,2)+MultPDFScaled,...
           'p','Markersize', msize, 'color', [0.2,0.2,0.2]);
end

if handles.dim == 3 % 3-d model
    msize = min((10/handles.trials)*5,10);   % adjust marker size according to trials if trials>5
    plot3(outcomes(:,1)+MultPDFScaled,outcomes(:,2)+MultPDFScaled,outcomes(:,3)+MultPDFScaled,...
           'p','Markersize', msize, 'color', [0.2,0.2,0.2]);
end

hold off;

% adjust axis lengths - default, fits most cases except when number of
% trials is small
axisLength = (handles.trials)*1.2;
% allow to expand if necessary
if max(outcomes(:,1)+MultPDFScaled)>axisLength
        axisLength =max(outcomes(:,1)+MultPDFScaled);
end

% set the axis length
set(handles.dataplot,'XLim',[0, axisLength]);
set(handles.dataplot,'YLim',[0, axisLength]);
set(handles.dataplot,'ZLim',[0, axisLength]);

% set up an array to hold the accumulated number of balls arriving at at
% one point (ie, bucket in the array buckets)
% Note: not all elements of the array buckets are valid ending points,
% Also note that at any stage not
% all valid buckets will necessarily have had a ball land in them
handles.buckets=zeros(handles.trials+1, handles.trials+1, handles.trials+1);

% set colour for history plot
handles.historyCol = [0.8 0.8 0.9];
    
% record that model has been loaded
handles.isModelLoaded = 1; 

%reset handle for what replication we are on (used by DoOne push button)
handles.rindex = 1;

% close the waitbar
close(wb);

% Update handles structure
guidata(hObject, handles);

updatedHandles = handles;


% --- Executes during object creation, after setting all properties.
function DoAll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DoAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object creation, after setting all properties.
function DoOne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DoOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ChangeSeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChangeSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function CloseButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
