% GUI Inversion sampler
% An inversion sampler GUI

% Available target distributions:
%   Uniform(a, b) where a and b are upper and lower bounds, b > a
%   Exponential(r) where r>0 is rate parameter
%   Laplace(l, r) where l is location parameter and r>0 is rate parameter
%   Cauchy (l, s) were l is location paramter and s>0 is scale paramter

% Error message shown if parameters not compliant with above specs

% GUI shows the target pdf and cdf, the inverse cdf,
%   and also histograms for the random uniform(0,1) values used to generate
%   the values from the target, and the values from the target distribution 

% GUI allows user to draw one, 10, 100 or 1000 samples
% For one sample, shows process of drawing random uniform(0,1) and using
%   inverse cdf to find equivalent rv value
% For each button press, GUI draws point(s) found onto horizontal axis of pdf
%   and lines on target cdf showing how points are generated

% Points found in previous button presses since whole sample was reset
%   continue to be shown in a lighter colour on pdf
% Lines on cdf from previous button presses continue to be shown up to a 
%   maximum number of history lines because too many history lines just
%   obscures the whole thing.  

% Reset sample button clears the current sample and starts again (ie clears
%   all histogram data and points/lines shown on pdf, cdf, etc

% Random number generator seed can be changed with Change prng seed button


function varargout = guiInversionSampler(varargin)
% GUIINVERSIONSAMPLER M-file for guiInversionSampler.fig
%      GUIINVERSIONSAMPLER, by itself, creates a new GUIINVERSIONSAMPLER or raises the existing
%      singleton*.
%
%      H = GUIINVERSIONSAMPLER returns the handle to a new GUIINVERSIONSAMPLER or the handle to
%      the existing singleton*.
%
%      GUIINVERSIONSAMPLER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIINVERSIONSAMPLER.M with the given input arguments.
%
%      GUIINVERSIONSAMPLER('Property','Value',...) creates a new GUIINVERSIONSAMPLER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiInversionSampler_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiInversionSampler_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiInversionSampler

% Last Modified by GUIDE v2.5 22-Jul-2009 11:54:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiInversionSampler_OpeningFcn, ...
                   'gui_OutputFcn',  @guiInversionSampler_OutputFcn, ...
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


% --- Executes just before guiInversionSampler is made visible.
function guiInversionSampler_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to guiInversionSampler (see VARARGIN)

    % Choose default command line output for guiInversionSampler
    handles.output = hObject;

    % ------------------  up handles for gui parameters ----------------
    % handle for pseudo-random number generator seed
    handles.prng_seed=88;

    % handle for minimum number of datapoints for histogram
    handles.HistMin = 10;

    % handle for default maximum 'history lines' from previous samples to show on cdf
    handles.DefaultMaxHistoryLines = 99;

    % handle for maximum 'history lines' from previous samples to show on cdf
    handles.MaxHistoryLines = handles.DefaultMaxHistoryLines;

    % handle for number of 'history lines' from previous samples shown on cdf
    handles.NumHistoryLines = 0;

    % handle for plot line width 1
    handles.PlotLineWidth1 = 2;

    % handle for plot line width 2
    handles.PlotLineWidth2 = 0.5;

    % handle for colour of inverse F x axis and sampled u
    handles.UniformColour = [0 0.7 0.3];

    % handle for colour of target pdf, cdf and inverse cdf plots
    handles.DistnPlotColour = [0 0 1];

    % handle for colour of sample histogram
    handles.SampleHistColour = [0 0.2 0.8];

    % handle for colour of uniform 'sample' histogram
    handles.UniformHistColour = [0.6 0.6 0.6];

    % handle for colour of dotted lines on inverse cdf and target cdf
    handles.DottedCurrentColour = [1 0 0];

    % handle for colour of dotted lines on inverse cdf and target cdf
    handles.DottedHistoryColour = [0.9255 0.4980 0.6431];

    % Set up array of structures holding parameters, functions and axes limits
    % The array of structs is called functFormulae
    % This is part of the gui data stored in the struct handles
    % so we refer to handles.functFormulae for the array
    % and add a subscript for which element of the array the particular struct
    % we want occupies and then add a name for the element of the struct
    % Each struct will finally consist of the elements:
    % name / a name for the distribution;
    % param1 / first parameter
    % param2 / second parameter
    % tails / the cut off tail probability for display
    % xmin / minimum on x axis for pdf, ie min of the range of X we show in pdf
    % xmax / maximum on x axis for pdf, ie max of the range of X we show in pdf
    % ymin / minimum on y axis for pdf, usually <= min for f(x) we show in pdf
    % ymax / maximum on y axis for pdf, usually >= max for f(x) we show in pdf
    % pdf / a function handle for the pdf function
    % cdf / a function handle for the cdf function
    % invcdf / a function handlef for the inverse cdf function

    % distributions should be ordered in the array in the same order as
    % they appear in the popup menu for choosing a distribution
    % so that the number of the distribution selected is the same as the 
    % index of that distribution's struct in the struct array

    % default values for uniform(param1,param2) distribution
    handles.functFormulae(1).name = 'Uniform';
    handles.functFormulae(1).param1 = -5; % first parameter
    handles.functFormulae(1).param2 = 5; % second parameter
    handles.functFormulae(1).tails=0; % not used

    % default values for Exponential(param1)
    handles.functFormulae(2).name = 'Exponential';
    handles.functFormulae(2).param1 = 0.5;
    handles.functFormulae(2).param2 = 0; % will not be visible or used
    handles.functFormulae(2).tails=.0155; % handle for tail of probability distribution not to show

    % default values for Laplace(param1)
    handles.functFormulae(3).name = 'Laplace';
    handles.functFormulae(3).param1 = 0;
    handles.functFormulae(3).param2 = 5;  
    handles.functFormulae(3).tails=.0015; % handle for tails of probability distribution not to show

    % default values for Standard Cauchy
    handles.functFormulae(4).name = 'Standard Cauchy';
    handles.functFormulae(4).param1 = 0;
    handles.functFormulae(4).param2 = 1;
    handles.functFormulae(4).tails=.0255; % handle for tails of probability distribution not to show

    % set show parameters on gui

    % the default distribution selection
    set(handles.DistnSelection, 'value', 1);

    % set index for distribution/set of formulae to use as default
    handles.indexFormulae = get(handles.DistnSelection,'Value');

    resetParameterDisplay(hObject, handles);


    % UIWAIT makes guiInversionSampler wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiInversionSampler_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;



% --- Executes on selection change in DistnSelection.
function DistnSelection_Callback(hObject, eventdata, handles)
    % hObject    handle to DistnSelection (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % get index for set of formulae to use from menu selection
    handles.indexFormulae = get(hObject,'Value');

    % Update handles structure
    guidata(hObject, handles);

    % reset parameter display;
    resetParameterDisplay(hObject, handles)

% function to reset parameter input when distribution is set/selected
function resetParameterDisplay(hObject, handles)
    
    % display default parameters for this distribution
    set(handles.Parameter1, 'String', num2str(handles.functFormulae(handles.indexFormulae).param1, '%5.2f'));
    set(handles.Parameter2, 'String', num2str(handles.functFormulae(handles.indexFormulae).param2, '%5.2f'));

    set(handles.Parameter2Label, 'visible', 'on');
        set(handles.Parameter2, 'visible', 'on');

    switch handles.indexFormulae
        case 1 % uniform
            set (handles.Parameter1Label, 'String', 'Lower bound');
            set (handles.Parameter2Label, 'String', 'Upper bound');

        case 2 % exponential
            set (handles.Parameter1Label, 'String', 'Rate parameter');

            set(handles.Parameter2Label, 'visible', 'off');
            set(handles.Parameter2, 'visible', 'off');
        case 3 % laplace
            set (handles.Parameter1Label, 'String', 'Location parameter');
            set (handles.Parameter2Label, 'String', 'Rate parameter');
        case 4 % cauchy
            set (handles.Parameter1Label, 'String', 'Location parameter');
            set (handles.Parameter2Label, 'String', 'Scale parameter');    
    end

    % Update handles structure
    guidata(hObject, handles);

    % Displays
    doDisplays(hObject, handles);


% Hints: contents = get(hObject,'String') returns DistnSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DistnSelection


% --- Executes during object creation, after setting all properties.
    function DistnSelection_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to DistnSelection (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


%---------------------------- edit boxes for parameter values

function Parameter1_Callback(hObject, eventdata, handles)
    % hObject    handle to Parameter1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    handles.functFormulae(handles.indexFormulae).param1 = ...
        str2double(get(hObject,'String')); % returns contents of Parameter1 as a double

    % display to 2 dps
    set(handles.Parameter1, 'String', ...
        num2str(handles.functFormulae(handles.indexFormulae).param1, '%5.2f'));

    % Update handles structure
    guidata(hObject, handles);

    % Displays
    doDisplays(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Parameter1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to Parameter1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function Parameter2_Callback(hObject, eventdata, handles)
    % hObject    handle to Parameter2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    handles.functFormulae(handles.indexFormulae).param2 = ...
        str2double(get(hObject,'String')); % returns contents of Parameter2 as a double

    % display to two dps
    set(handles.Parameter2, 'String', ...
        num2str(handles.functFormulae(handles.indexFormulae).param2, '%5.2f'));

    % Update handles structure
    guidata(hObject, handles);

    % Displays
    doDisplays(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Parameter2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to Parameter2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



% function to check parameters make sense and if so,
% set mins and maxes for given parameters and then call function to display
% function
function doDisplays(hObject, handles)
        
    if handles.indexFormulae == 1 && ...
            (handles.functFormulae(handles.indexFormulae).param2 <= ...
            handles.functFormulae(handles.indexFormulae).param1) % uniform
        % uniform parameters don't make sense - disable action buttons
        disableSampleButton(hObject, handles);

    elseif handles.indexFormulae == 2 && ...
            (handles.functFormulae(handles.indexFormulae).param1 <= 0)
        % exponential rate parameter does not make sense - disable action buttons
        disableSampleButton(hObject, handles);

    elseif handles.indexFormulae == 3 && ...
            (handles.functFormulae(handles.indexFormulae).param2 <= 0)
        % laplace rate parameter does not make sense - disable action buttons
        disableSampleButton(hObject, handles);        

    elseif handles.indexFormulae == 4 && ...
            (handles.functFormulae(handles.indexFormulae).param2 <= 0)
        % cauchy scale parameter does not make sense - disable action buttons
        disableSampleButton(hObject, handles);  
    
    else % all okay
    
        % calculate mins and maxs based on new parameters
        handles = setTargetFunction(hObject, handles);

        % Update handles structure
        guidata(hObject, handles);

        % enable the sampling buttons
        enableSampleButton(hObject, handles);

        % use setAxes function to
        % show the selected distribution on the axes for target pdf, target cdf,
        % inverse target cdf
        handles=setAxes(hObject, handles);

        % Update handles structure
        guidata(hObject, handles);

    end
    % end function

% function to disable sampling buttons and display parameter error message
function disableSampleButton(hObject, handles)
    set(handles.ParameterWarning, 'Visible', 'on');
    set(handles.SampleOne, 'enable', 'off');
    set(handles.Sample10, 'enable', 'off');
    set(handles.Sample100, 'enable', 'off');
    set(handles.Sample1000, 'enable', 'off');

% function to enable sampling buttons and display parameter error message

function enableSampleButton(hObject, handles)
    set(handles.ParameterWarning, 'Visible', 'off');
    set(handles.SampleOne, 'enable', 'on');
    set(handles.Sample10, 'enable', 'on');
    set(handles.Sample100, 'enable', 'on');
    set(handles.Sample1000, 'enable', 'on');
    
%---------------------------- sample size display is not enabled so these callbacks are just stubs 
% ie object never has to react to user event

function SampleSizeDisp_Callback(hObject, eventdata, handles)
    % hObject    handle to SampleSizeDisp (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of SampleSizeDisp as text
    %        str2double(get(hObject,'String')) returns contents of SampleSizeDisp as a double


% --- Executes during object creation, after setting all properties.
function SampleSizeDisp_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to SampleSizeDisp (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% ----function to calculate min and max display values for the chosen function
function updatedHandles = setTargetFunction(hObject, handles)
    
    if handles.indexFormulae == 1 % uniform
        handles.functFormulae(handles.indexFormulae).pdf = ...
            @(x) 1/(handles.functFormulae(handles.indexFormulae).param2 -...
            handles.functFormulae(handles.indexFormulae).param1);
        handles.functFormulae(handles.indexFormulae).cdf = ...
            @(x) (x-handles.functFormulae(handles.indexFormulae).param1)/...
            (handles.functFormulae(handles.indexFormulae).param2- ...
            handles.functFormulae(handles.indexFormulae).param1);
        handles.functFormulae(handles.indexFormulae).invcdf = ...
        @(u) u*(handles.functFormulae(handles.indexFormulae).param2 -...
        handles.functFormulae(handles.indexFormulae).param1)+ ...
            handles.functFormulae(handles.indexFormulae).param1;

        handles.functFormulae(handles.indexFormulae).xmin = ...
            handles.functFormulae(handles.indexFormulae).param1; 
        handles.functFormulae(handles.indexFormulae).xmax = ...
            handles.functFormulae(handles.indexFormulae).param2; 
        handles.functFormulae(handles.indexFormulae).ymin = 0;
        handles.functFormulae(handles.indexFormulae).ymax = ...
            2/(handles.functFormulae(handles.indexFormulae).param2 - ...
            handles.functFormulae(handles.indexFormulae).param1);
    end
    
    if handles.indexFormulae == 2 % exponential
        handles.functFormulae(handles.indexFormulae).pdf = ...
            @(x) handles.functFormulae(handles.indexFormulae).param1*...
            exp(-handles.functFormulae(handles.indexFormulae).param1*x);
        handles.functFormulae(handles.indexFormulae).cdf = ...
            @(x) 1-exp(-handles.functFormulae(handles.indexFormulae).param1*x);
        handles.functFormulae(handles.indexFormulae).invcdf = ...
            @(u) -1/handles.functFormulae(handles.indexFormulae).param1*log(1-u);
        % use invcdf and the tail probability to cut out to find the xmax
        xmin = 0;
        xmax = handles.functFormulae(handles.indexFormulae).invcdf(1 - ...
            handles.functFormulae(handles.indexFormulae).tails);
        handles.functFormulae(handles.indexFormulae).xmin = xmin;
        handles.functFormulae(handles.indexFormulae).xmax = xmax;
        handles.functFormulae(handles.indexFormulae).ymin = 0;
        xinc = (xmax-xmin)/1000;
        xdata = xmin: xinc: xmax;
        handles.functFormulae(handles.indexFormulae).ymax = ...
            max(arrayfun(handles.functFormulae(handles.indexFormulae).pdf, xdata));
    end
    
    if handles.indexFormulae == 3 % laplace
        handles.functFormulae(handles.indexFormulae).pdf = ...
            @(x) handles.functFormulae(handles.indexFormulae).param2/...
            2*exp(-handles.functFormulae(handles.indexFormulae).param2*...
            abs(x - handles.functFormulae(handles.indexFormulae).param1));
        handles.functFormulae(handles.indexFormulae).cdf = ...
            @(x) 0.5*(1+sign(x - handles.functFormulae(handles.indexFormulae).param1)*...
            (1-exp(-handles.functFormulae(handles.indexFormulae).param2*abs(x - ...
            handles.functFormulae(handles.indexFormulae).param1))));
        handles.functFormulae(handles.indexFormulae).invcdf = ...
            @(u) handles.functFormulae(handles.indexFormulae).param1 - ...
            1/handles.functFormulae(handles.indexFormulae).param2*sign(u-0.5)*log(1-2*abs(u-0.5));
       
        % work down from the centre point to find limits
        xmin = handles.functFormulae(handles.indexFormulae).param1;
        cdf = handles.functFormulae(handles.indexFormulae).cdf(xmin);
        while cdf > handles.functFormulae(handles.indexFormulae).tails
            xmin = xmin - .1;
            cdf = handles.functFormulae(handles.indexFormulae).cdf(xmin);
        end
        handles.functFormulae(handles.indexFormulae).xmin = xmin;
        xmax = 2*handles.functFormulae(handles.indexFormulae).param1 - xmin;
        handles.functFormulae(handles.indexFormulae).xmax = xmax;
        handles.functFormulae(handles.indexFormulae).ymin = 0;
        xinc = (xmax-xmin)/1000;
        xdata = xmin: xinc: xmax;
        handles.functFormulae(handles.indexFormulae).ymax = ...
            max(arrayfun(handles.functFormulae(handles.indexFormulae).pdf, xdata));
    end
    
    if handles.indexFormulae == 4 % cauchy
        M = handles.functFormulae(handles.indexFormulae).param1;
        G = handles.functFormulae(handles.indexFormulae).param2;
        handles.functFormulae(handles.indexFormulae).pdf = @(x) 1/(pi*G*(1+((x-M)/G)^2));
        handles.functFormulae(handles.indexFormulae).cdf = @(x) atan((x-M)/G)/pi + 0.5;
        handles.functFormulae(handles.indexFormulae).invcdf = @(u) M + G*tan(pi*(u-0.5));
        
        % work down from the centre point to find limits
        xmin = handles.functFormulae(handles.indexFormulae).param1;
        cdf = handles.functFormulae(handles.indexFormulae).cdf(xmin);
        while cdf > handles.functFormulae(handles.indexFormulae).tails
            xmin = xmin - 0.1;
            cdf = handles.functFormulae(handles.indexFormulae).cdf(xmin);
        end
        handles.functFormulae(handles.indexFormulae).xmin = xmin; 
        xmax = 2*handles.functFormulae(handles.indexFormulae).param1 - xmin;
        handles.functFormulae(handles.indexFormulae).xmax = xmax;
        handles.functFormulae(handles.indexFormulae).ymin = 0;
        xinc = (xmax-xmin)/1000;
        xdata = xmin: xinc: xmax;
        handles.functFormulae(handles.indexFormulae).ymax = ...
            max(arrayfun(handles.functFormulae(handles.indexFormulae).pdf, xdata));
    end
    
    updatedHandles = handles;
    % end of function
    


%---------------------------- function to reset plots when a new distribution is chosen 
function updatedHandles = setAxes(hObject, handles)
    % function to set up or update the basic figure
    % returns the updated handles after setting up the figure

    %handle for pseudo-random number generator setup
    handles.prng=@()(rand('twister', handles.prng_seed));

    % reset handle for number of 'history lines' from previous samples shown on cdf
    handles.NumHistoryLines = 0;

    % call function to plot the target PDF
    % this updates the handles structure
    handles = setTargetPDF(hObject, handles);

    % call function to plot the target CDF
    setTargetF(handles);

    % call function to plot the inverse target CDF
    setInverseF(handles);

    % call function to clear the sample and set up sample histograms
    handles = resetSample(hObject, handles);

    updatedHandles = handles;
    % end function

%---------------------------- function to plot the target PDF
function updatedHandles = setTargetPDF(hObject, handles)

    %clear the figure
    axes(handles.TargetPDF);
    cla;    % clear the axes

    % make the x data
    Xinc = (handles.functFormulae(handles.indexFormulae).xmax- ...
        handles.functFormulae(handles.indexFormulae).xmin)/1000; 
    Xdata = handles.functFormulae(handles.indexFormulae).xmin: ...
        Xinc: ...
        handles.functFormulae(handles.indexFormulae).xmax;  % x axis data

    % make the y data
    Ydata = arrayfun(handles.functFormulae(handles.indexFormulae).pdf, Xdata);

    % plot the x and y data
    plot(Xdata, Ydata, 'Color', handles.DistnPlotColour,'LineWidth',handles.PlotLineWidth1);

    % set the x ticks
    % aiming for at least tickmin tick marks and labels, set according to scale
    % of data
    tickmin = 5.0;
    incscale = 1000;
    xdiffmin = (handles.functFormulae(handles.indexFormulae).xmax- ...
        handles.functFormulae(handles.indexFormulae).xmin)/tickmin;
    while xdiffmin < incscale
        incscale = incscale/10.0;
    end
    xtickinc = floor(xdiffmin/incscale)*incscale;
    handles.XTicks = floor(handles.functFormulae(handles.indexFormulae).xmin/xtickinc)*xtickinc: ...
        xtickinc: ...
        floor(handles.functFormulae(handles.indexFormulae).xmax/xtickinc)*xtickinc;
    set(handles.TargetPDF,'XTick',handles.XTicks);
    set(handles.TargetPDF,'XTickLabel',handles.XTicks);

    % set the y ticks
    % aiming for at least tickmin (set above) tick marks and labels, set according to scale
    % of data
    incscale = 1000;
    ydiffmin = (handles.functFormulae(handles.indexFormulae).ymax- ...
        handles.functFormulae(handles.indexFormulae).ymin)/tickmin;
    while ydiffmin < incscale
        incscale = incscale/10.0;
    end
    ytickinc = floor(ydiffmin/incscale)*incscale;
    handles.YTicks = floor(handles.functFormulae(handles.indexFormulae).ymin/ytickinc)*ytickinc: ...
        ytickinc: ...
        floor(handles.functFormulae(handles.indexFormulae).ymax/ytickinc)*ytickinc;
    set(handles.TargetPDF,'YTick',handles.YTicks);
    set(handles.TargetPDF,'YTickLabel',handles.YTicks);

    % add a little margin on top of the ymax
    marg = (handles.functFormulae(handles.indexFormulae).ymax - ...
        handles.functFormulae(handles.indexFormulae).ymin)/20.0;
    handles.functFormulae(handles.indexFormulae).ymax = ...
        handles.functFormulae(handles.indexFormulae).ymax + marg;
    % set the x and y axis limits
    set(handles.TargetPDF,'XLim',[handles.functFormulae(handles.indexFormulae).xmin ...
        handles.functFormulae(handles.indexFormulae).xmax]);
    set(handles.TargetPDF,'YLim',[handles.functFormulae(handles.indexFormulae).ymin ...
        handles.functFormulae(handles.indexFormulae).ymax]);

    

    % box off, ticks out
    box off;
    set(handles.TargetPDF,'TickDir','out');

    % Update handles structure
    guidata(hObject, handles);

    updatedHandles = handles;
    % end function


%---------------------------- function to plot the target CDF
function setTargetF(handles)

    %clear the figure
    axes(handles.TargetF);
    cla;    % clear the axes

    % make the x data
    Xinc = (handles.functFormulae(handles.indexFormulae).xmax- ...
        handles.functFormulae(handles.indexFormulae).xmin)/1000; 
    Xdata = handles.functFormulae(handles.indexFormulae).xmin: ...
        Xinc: ...
        handles.functFormulae(handles.indexFormulae).xmax;  % x axis data

    % make the y data
    Ydata = arrayfun(handles.functFormulae(handles.indexFormulae).cdf, Xdata);

    % plot the x and y data
    plot(Xdata, Ydata, 'Color', handles.DistnPlotColour,'LineWidth',handles.PlotLineWidth1);

    % set the x and y axis limits
    set(handles.TargetF,'XLim',[handles.functFormulae(handles.indexFormulae).xmin ...
        handles.functFormulae(handles.indexFormulae).xmax]);
    set(handles.TargetF,'YLim',[0 1]);

    % set the x ticks as for the pdf
    set(handles.TargetF,'XTick',handles.XTicks);
    set(handles.TargetF,'XTickLabel',handles.XTicks);

    % box off, ticks out
    box off;
    set(handles.TargetF,'TickDir','out');
    % end function

%---------------------------- function to plot the inverse target CDF
function setInverseF(handles)

    %clear the figure
    axes(handles.InverseF);
    cla;    % clear the axes

    % make the x data
    Xdata = 0: 0.001 : 1;  % x axis data

    % make the y data
    Ydata = arrayfun(handles.functFormulae(handles.indexFormulae).invcdf, Xdata);

    % plot the x and y data
    plot(Xdata, Ydata, 'Color', handles.DistnPlotColour,'LineWidth',handles.PlotLineWidth1);

    % set the x and y axis limits
    set(handles.InverseF,'XLim',[0 1]);
    set(handles.InverseF,'YLim',[handles.functFormulae(handles.indexFormulae).xmin ...
        handles.functFormulae(handles.indexFormulae).xmax]);

    % set the y ticks to be the same as the xticks on the pdf and cdf
    set(handles.InverseF,'YTick',handles.XTicks);
    set(handles.InverseF,'YTickLabel',handles.XTicks);

    % box off, ticks out
    box off;
    set(handles.InverseF,'TickDir','out');

    % X axis colour to green
    set(handles.InverseF,'XColor',handles.UniformColour);
    % end function

% plot a dotted line from (xmin,u) to (x,u) on target cdf
function HistoryLineDrawHorizontal(hObject, handles, x, u)

    axes(handles.TargetF);
    hold on
    plot([handles.functFormulae(handles.indexFormulae).xmin,x],[u,u], ...
    'Color',handles.DottedCurrentColour,'LineStyle',':','LineWidth',handles.PlotLineWidth1);
    hold off
    % end function

% plot a dotted line from (x,0) to (x,u) on target cdf
function HistoryLineDrawVertical(hObject, handles, x, u)

    axes(handles.TargetF);
    hold on
    plot([x,x],[0,u], ...
        'Color',handles.DottedCurrentColour,'LineStyle',':','LineWidth',handles.PlotLineWidth1);
    hold off
    % end function
    


% --------------------- function to clear the sample found so far
function h=resetSample(hObject, handles)
% executes on initialisation and when there is a change in distribution or random number seed

    handles.SampleData=[]; % clear the sample data array
    handles.UniformData=[]; % clear the 'sample' of uniform rvs picked so far
    handles.SampleSize=0;  % set the current sample size in the gui data to 0
    handles.NumberToDraw = 0; % set the number of samples to be drawn to 0

    % reset maximum 'history lines' from previous samples to show on cdf
    handles.MaxHistoryLines = handles.DefaultMaxHistoryLines;

    % reset the displayed samples size
    set(handles.SampleSizeDisp,'String',int2str(handles.SampleSize));

    % clear the figure for the sample histogram
    axes(handles.SampleHist);
    cla;    

    % clear the uniform histogram axes
    axes(handles.UniformHist);
    cla;   

    % set the x and y axis limits on the sample axis
    set(handles.SampleHist,'XLim',[handles.functFormulae(handles.indexFormulae).xmin ...
        handles.functFormulae(handles.indexFormulae).xmax]);
    set(handles.SampleHist,'YLim',[handles.functFormulae(handles.indexFormulae).ymin ...
        handles.functFormulae(handles.indexFormulae).ymax]);

    % set the x ticks on the sample axis as for the pdf
    set(handles.SampleHist,'XTick',handles.XTicks);
    set(handles.SampleHist,'XTickLabel',handles.XTicks);

    % box off, ticks out
    box off;
    set(handles.SampleHist,'TickDir','out');

    % nextplot = replacechildren - this replaces the plotted data but not axes properties
    set(handles.SampleHist,'NextPlot','replacechildren');
    set(handles.UniformHist,'NextPlot','replacechildren');

    % Update handles structure
    guidata(hObject, handles);

    h=handles;
    % end function


% --------------------------- Executes on button press in SampleOne.
function SampleOne_Callback(hObject, eventdata, handles)
% hObject    handle to SampleOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % pushing this button draws one sample

    % change colour and width of lines for last sample on Target CDF to the history colour
    axes(handles.TargetF);
    h = findobj('Color',handles.DottedCurrentColour,'LineWidth',handles.PlotLineWidth1);
    set(h,'Color',handles.DottedHistoryColour,'LineWidth',handles.PlotLineWidth2);

    % change points already on target pdf as star to small pt
    axes(handles.TargetPDF);
    h = findobj('Marker','p');
    set(h, 'MarkerEdgeColor',handles.DottedHistoryColour,'Marker','.', ...
        'MarkerFaceColor', handles.DottedHistoryColour, 'MarkerSize', 10); 


    % draw a uniform u
    u=rand;

    % calculate the corresponding x from the inverse cdf
    x=handles.functFormulae(handles.indexFormulae).invcdf(u);

    % call function to resize history line data
    % history line data is shown on target cdf
    % and there is a maximum shown so we may need to remove 1 earliest line from the data
    handles = resizeHistory(hObject, handles,1);

    % Update handles structure
    guidata(hObject, handles);

    % the target CDF and PDF are not replotted while we only do one sample at a time

    % call function to replot the inverse target CDF (clears lines, text% etc)
    setInverseF(handles);

    % show u on the bottom of the inverse cdf
    axes(handles.InverseF);
    hold on

    % plot an '*' at (u,xmin) on the bottom of the inverse cdf
    plot(u, handles.functFormulae(handles.indexFormulae).xmin, ...
        'Color',handles.UniformColour,'Marker','p', ...
        'MarkerFaceColor',handles.UniformColour, 'MarkerSize', 10); 

    % show some text pointing to the point
    s = ['\leftarrow u= ' num2str(u,3)];
    text(u,handles.functFormulae(handles.indexFormulae).xmin,s, ...
        'VerticalAlignment', 'baseline', ...
        'FontSize',14); 

    pause(0.4);

    % plot a dotted line from (u,minx) to (u,x) on inverse cdf
    plot([u,u],[handles.functFormulae(handles.indexFormulae).xmin,x], ...
        'Color',handles.DottedCurrentColour,'LineStyle',':','LineWidth',handles.PlotLineWidth1);

    % plot a  dotted line from (minx,u) to (x,u) on target cdf
    HistoryLineDrawHorizontal(hObject,handles,x,u)

    pause (0.4);
    % plot a red dotted line from (0,x) to (u,x) on inverse cdf
    axes(handles.InverseF);
    plot([0,u],[x,x], ...
        'Color',handles.DottedCurrentColour,'LineStyle',':','LineWidth',handles.PlotLineWidth1);

    % plot a  dotted line from (x,0) to (x,u) on target cdf
    HistoryLineDrawVertical(hObject,handles,x,u)

    pause(0.3);

    % show some text pointing to the point on the inverse cdf
    axes(handles.InverseF);
    s = ['x=' num2str(x,3) '\rightarrow'];
     text(0,x,s, ...
        'HorizontalAlignment','right', ...
        'FontSize',14);

    % show x as a * on x axis of the target pdf
    axes(handles.TargetPDF);
    hold on;
    plot(x, 0, ...
        'MarkerEdgeColor',handles.DottedCurrentColour,'Marker','p', ...
        'MarkerFaceColor', handles.DottedCurrentColour, 'MarkerSize', 10); 
    hold off;


    % take the hold off the inverse F
    axes(handles.InverseF);
    hold off

    % increment the sample size
    handles.SampleSize=handles.SampleSize+1;

    % add the new x and u to the history lines data
    handles = addHistory(hObject, handles, x, u);

    % reset the displayed samples size
    set(handles.SampleSizeDisp,'String',int2str(handles.SampleSize));

    %add x and u to the sample data arrays
    if handles.SampleSize==1    % if this is the first sample initiate arrays
        handles.SampleData=[x];
        handles.UniformData=[u];
    else %otherwise add to the sample arrays
        handles.SampleData=[handles.SampleData,x];
        handles.UniformData=[handles.UniformData,u];
    end

    % Update handles structure
    guidata(hObject, handles);

    % update the Sample histogram by calling myHistogram function 
    myHistogram(handles, handles.SampleHist, handles.SampleData, ...
        [handles.functFormulae(handles.indexFormulae).xmin ...
        handles.functFormulae(handles.indexFormulae).xmax], handles.SampleHistColour)

    % update the Uniform 'sample' histogram by calling myHistogram function
    myHistogram(handles, handles.UniformHist, handles.UniformData, ...
        [0 1], handles.UniformHistColour)

    % ---------------------- end of function

% ----------------- function to resize matrices for data to be plotted
% as history lines on the cdf.
% The maximum number of lines to be plotted is in handles.MaxHistoryLines
% and if the maximum to be shown has already been reached the first
% elements are dropped
% History points data is not resized
function updatedHandles = resizeHistory(hObject, handles, numToDrop)

     % if enough lines already we need to reduce to handles.MaxHistoryLines-numToDrop lines
     while handles.NumHistoryLines > (handles.MaxHistoryLines - numToDrop)...
             && handles.NumHistoryLines > 0
        % covers any mistake that makes NumHistoryLines>MaxHistoryLine just in case

        % resize the lines
        handles.DataHistoryLinesX(:,1)= []; % delete the first column
        handles.DataHistoryLinesY(:,1)= []; % delete the first column

        % resize the points
        %handles.DataHistoryPtsX(:,1)= []; % delete the first column
        %handles.DataHistoryPtsY(:,1)= []; % delete the first column

        % decrement NumHistoryLines
        handles.NumHistoryLines = handles.NumHistoryLines - 1; 

    end % end while loop if we need to cut some lines out of the history lines data

    % history lines data should have at most MaxHistoryLines-numToDrop columns in now

    % Update handles structure
    guidata(hObject, handles);

    updatedHandles = handles; % return the updated handles to the function's caller
    % ---------------------- end of function

% ---------------------- function to add new data to history data
% this is called after the history data has been resized but the 
% number of history lines being added could itself be more than 
% the allowed max so we check again that we don't need to throw some out
% MaxHistoryLines specifies the maximum hitory lines allowed on
% the Target CDF
% All history points on target PDF are plotted
function updatedHandles = addHistory(hObject, handles, newx, newu)
    
    if handles.NumHistoryLines > 0 % there is already some data
        % clear space if necessary
        if handles.NumHistoryLines > handles.MaxHistoryLines - 1
            % call function to resize history line data
            handles = resizeHistory(hObject, handles, 1);
            % Update handles structure
            guidata(hObject, handles);
        end

        % add data for new lines with horizontal concatenation
        handles.DataHistoryLinesX = [handles.DataHistoryLinesX ...
            [handles.functFormulae(handles.indexFormulae).xmin;newx;newx]];
        handles.DataHistoryLinesY = [handles.DataHistoryLinesY ...
            [newu;newu;0]];

        % increment NumHistoryLines
        handles.NumHistoryLines = handles.NumHistoryLines + 1;

        % add data for new points with horizontal concatenation
        handles.DataHistoryPtsX = [handles.DataHistoryPtsX newx];
        handles.DataHistoryPtsY = [handles.DataHistoryPtsY 0];

    end % end NumHistoryLines > 0

    if handles.NumHistoryLines == 0 % no history lines yet
        % just put in the new data
        % data for lines
        handles.DataHistoryLinesX = [handles.functFormulae(handles.indexFormulae).xmin;newx;newx];
        handles.DataHistoryLinesY = [newu;newu;0];
        %data for points
        handles.DataHistoryPtsX = [newx];
        handles.DataHistoryPtsY = [0];

        % increment the counter
        handles.NumHistoryLines = handles.NumHistoryLines + 1;

    end % end if NumHistoryLines = 0

    % Update handles structure
    guidata(hObject, handles);

    updatedHandles = handles; % return the updated handles to the function's caller

    % ---------------------- end of function


% --- Executes on button press in Sample10.
function Sample10_Callback(hObject, eventdata, handles)
    % hObject    handle to Sample10 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % set the number of samples to draw
    handles.NumberToDraw = 10;

    % Update handles structure
    guidata(hObject, handles);

    % call the function to draw samples, with the number to be drawn being
    % passed within the handles struct
    DrawSamples(hObject, handles);

    % ---------------------- end of function


% --- Executes on button press in Sample100.
function Sample100_Callback(hObject, eventdata, handles)
    % hObject    handle to Sample100 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % set the number of samples to draw
    handles.NumberToDraw = 100;

    % Update handles structure
    guidata(hObject, handles);

    % call the function to draw samples, with the number to be drawn being
    % passed within the handles struct
    DrawSamples(hObject, handles);

    % ---------------------- end of function


% --- Executes on button press in Sample1000.
function Sample1000_Callback(hObject, eventdata, handles)
    % hObject    handle to Sample1000 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % set the number of samples to draw
    handles.NumberToDraw = 1000;

    % Update handles structure
    guidata(hObject, handles);

    % call the function to draw samples, with the number to be drawn being
    % passed within the handles struct
    DrawSamples(hObject, handles);

    % ---------------------- end of function



% --------------------- function to draw multiple samples
% the number of samples to draw is passed in the handles struct
function DrawSamples(hObject, handles)
    
    %Only redraw if doing the sample will put us over the max number of
    % history lines
    if handles.NumberToDraw > handles.MaxHistoryLines - handles.NumHistoryLines

        % call function to resize history line data
        % if we use the sample 10 or 100 or 1000 buttons the CDF will be redrawn with
        % the maximum number on there, so we may need to remove some earliest line from the data
        handles = resizeHistory(hObject, handles, ...
            handles.NumberToDraw -(handles.MaxHistoryLines - handles.NumHistoryLines));
        % Update handles structure
        guidata(hObject, handles);

        % delete lines already on Target CDF
        axes(handles.TargetF);
        delete(findobj('Color',handles.DottedCurrentColour));
        delete(findobj('Color',handles.DottedHistoryColour));
        % All points already on target pdf are retained
        %axes(handles.TargetPDF);
        %delete(findobj('MarkerEdgeColor',handles.DottedCurrentColour));
        %delete(findobj('MarkerEdgeColor',handles.DottedHistoryColour)); 

        % draw on the retained history lines and points
        if handles.NumHistoryLines > 0
            %plot the history lines on the target CDF if there are any

             axes(handles.TargetF);
             hold on
             plot(handles.DataHistoryLinesX,handles.DataHistoryLinesY, ...
                    'Color',handles.DottedHistoryColour,'LineStyle',':','LineWidth',handles.PlotLineWidth2);
             hold off

             % all points retained so no need to redraw
             %axes(handles.TargetPDF);
             %hold on
             %plot(handles.DataHistoryPtsX,handles.DataHistoryPtsY, ...
             %       'MarkerEdgeColor',handles.DottedHistoryColour,'Marker','.', ...
             %       'MarkerFaceColor', handles.DottedHistoryColour, ...
             %       'MarkerSize', 10);
             %hold off
        end
    else % if we don't redraw the history lines we need to change colour and width for the last set
        % need to do colour and width separately because they may be set separately
        axes(handles.TargetF);
        h = findobj('Color',handles.DottedCurrentColour); 
        set(h,'Color',handles.DottedHistoryColour);
        h = findobj('LineWidth',handles.PlotLineWidth1);
        set(h,'LineWidth',handles.PlotLineWidth2);
    end

    % make all points the history colour
    axes(handles.TargetPDF);
    h = findobj('MarkerEdgeColor',handles.DottedCurrentColour);
    set(h, 'MarkerEdgeColor',handles.DottedHistoryColour,'Marker','.', ...
        'MarkerFaceColor', handles.DottedHistoryColour, 'MarkerSize', 10);


    % store the current number of history lines
    % if we have had to clear out all the history data in the resize 
    % then NumHistoryLines will be 0 now
    OldNumHistoryLines = handles.NumHistoryLines;

    % call function to plot the inverse target CDF
    setInverseF(handles);

    % set up a wait bar
    wb = waitbar(0,'Please wait...');

    % for-loop for number of samples to be drawn
    for i = 1:handles.NumberToDraw

        waitbar(i/handles.NumberToDraw) % move the waitbar

        % draw a uniform u
        u=rand;

        % calculate the corresponding x from the inverse cdf
        x=handles.functFormulae(handles.indexFormulae).invcdf(u);

        % increment the sample size
        handles.SampleSize=handles.SampleSize+1;

        %add x and u to the sample data arrays
        if handles.SampleSize==1    % if this is the first sample initiate arrays
            handles.SampleData=[x];
            handles.UniformData=[u];
        else %otherwise add to the sample arrays
            handles.SampleData=[handles.SampleData,x];
            handles.UniformData=[handles.UniformData,u];
        end

        % add the new x and u to the history lines and points data
        handles = addHistory(hObject, handles, x, u);

    end % end of for loop to generate required number of samples

    % draw on the new lines and points
    % there will not necessarily be NumberToDraw new lines - if MaxHistoryLines
    % is less than NumToDraw, there will be less, ie starting with
    % OldNumHistoryLines+1 and up to NumHistoryLines
    % but there will be NumberToDraw new points

    % only use the thicker line if doing less than 50 samples
    % ie use the thinner lines but current colour for larger samples
    c = handles.DottedCurrentColour;
    p = 'p';
    if handles.NumberToDraw < 50
        lw = handles.PlotLineWidth1;
        s = 10;
    else
        lw = handles.PlotLineWidth2;
        s = 5;
    end

    axes(handles.TargetF);
    hold on
    plot(handles.DataHistoryLinesX(:,...
            OldNumHistoryLines+1:handles.NumHistoryLines),...
        handles.DataHistoryLinesY(:,...
            OldNumHistoryLines+1:handles.NumHistoryLines),...
            'Color',c,'LineStyle',':','LineWidth',lw);
    hold off

    % draw on all the points just made
    numDrawn = handles.NumberToDraw;
    sizePtsNow = size(handles.DataHistoryPtsX, 2);
    
    axes(handles.TargetPDF);
    hold on
    plot(handles.DataHistoryPtsX(:,...
            sizePtsNow-numDrawn+1:sizePtsNow),...
        handles.DataHistoryPtsY(:,...
            sizePtsNow-numDrawn+1:sizePtsNow),...
            'MarkerEdgeColor',c, 'Marker',p, 'MarkerFaceColor', c, ...
            'MarkerSize', s);
    hold off

    % reset the displayed sample size
    set(handles.SampleSizeDisp,'String',int2str(handles.SampleSize));

    % update the Sample histogram by calling myHistogram function 
    %myHistogram(handles.SampleHist, handles.SampleData, ...
     %   [handles.functFormulae(handles.indexFormulae).xmin ...
      %  handles.functFormulae(handles.indexFormulae).xmax], handles.SampleHistColour)
    myHistogram(handles, handles.SampleHist, handles.SampleData, ...
        [min(handles.SampleData) max(handles.SampleData)], ...
        handles.SampleHistColour)

    % update the Uniform 'sample' histogram by calling myHistogram function
    myHistogram(handles, handles.UniformHist, handles.UniformData, ...
        [0 1], handles.UniformHistColour)

    close(wb); % close the waitbar

% ---------------------- end of function


% --- Executes on button press in SampleClear.
function SampleClear_Callback(hObject, eventdata, handles)
    % hObject    handle to SampleClear (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % call function to clear and reset axes for currently selected distribution
    h=setAxes(hObject, handles);

    % ---------------------- end of function


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

    %re-intialise the fundamental sampler
    rand('twister', handles.prng_seed);

    % Update handles structure
    guidata(hObject, handles);

    % ---------------------- end of function


% --- Executes on button press in CloseButton.
% deletes the gui without asking for confirmation!
function CloseButton_Callback(hObject, eventdata, handles)
    % hObject    handle to CloseButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    %delete the gui without confirming!    
    delete(handles.figure1)

    % ---------------------- end of function



%------------------------------------ function to do histograms
% from histogram.m
% Plots density histogram for data in X.
%
% Usage: histogram(X,plotdata,bounds,colour);
%
  function myHistogram(handles, histplot, X, bounds, colour)
  %  an embedded version of Raaz's histogram function
    % Input: handles = gui  data
    %        histplot = what axes to plot on
    %        X = [array of data to plot]
    %        bounds = [lower bound , upper bound] for possible X values,
    %        colour in colour spec form, eg = [0 0 1] for blue
    %        
    % Remark: Bin origin determined by centering the histogram, ie. so that 
    % left and right bin edges extend beyond min(X) and max(X) respectively 
    % by equal amounts.
    %
    % Reference: Wand M.P. (1997), "Data-based choice of histogram bin width", 
    % American Statistician 51, 59-64.
  
  plotdata = 0; % plotdata (binary) = plot data points?
  % bwmethod (optional, default = 2) = method of computing bin width:
  %                 0 = Scott's normal reference rule,
  %                 1 = Wand's one-stage rule,
  %                 2 = Wand's two-stage rule,
  %                 3 = manual,
  bwmethod = 2;
  %        bw = manual bin width if bwmethod = 3.
  
  n = length(X); Y = zeros(1,n);
  
  % check if number of datapoints too small and put message on histograms & return if so
  if n < handles.HistMin
      
      Ylimits = get(histplot,'YLim');
      axes(histplot); % make this axis current
      text((bounds(1)+bounds(2))/2,(Ylimits(1)+Ylimits(2))/2,'sample too small', ...
          'HorizontalAlignment','Center','FontSize',10);
      
      return
  end
  % get here only if  enough datapoints for histogram
  
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
  axes(histplot);  
  
  if plotdata
     fill(XX,YY,colour,X,Y,[colour '.'])
  else
     fill(XX,YY,colour)
  end
  box off
 %xlabel('support'), ylabel('density')
    %set(histplot,'XLim', bounds);


  
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

  





