function varargout = covid(varargin)
% COVID MATLAB code for covid.fig
%      COVID, by itself, creates a new COVID or raises the existing
%      singleton*.
%
%      H = COVID returns the handle to a new COVID or the handle to
%      the existing singleton*.
%
%      COVID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COVID.M with the given input arguments.
%
%      COVID('Property','Value',...) creates a new COVID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before covid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to covid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help covid

% Last Modified by GUIDE v2.5 01-Apr-2020 17:44:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @covid_OpeningFcn, ...
    'gui_OutputFcn',  @covid_OutputFcn, ...
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


% --- Executes just before covid is made visible.
function covid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to covid (see VARARGIN)
clc;

handles.Pop     = 66000000;
handles.oldPop  = 0.18;
handles.rRate   = 0.99;
handles.dOldRate= 0.1;
handles.R       = 2.4;
handles.initInf = 5;
handles.t_inc   = 5.1;
% handles.t_inf   = 6.5;
handles.t_rec   = 18.8;
handles.alpha   = 1 / handles.t_inc;
handles.gamma   = 1 / handles.t_rec;
handles.beta    = handles.R * handles.gamma;

set( handles.stockData, 'Value', 1 );
handles.stockDataStr = {'United Kingdom', 'NorthernIreland', 'Italy', 'Korea, South', 'Sweden'};
handles.legendStr1 = {};
handles.legendStr2 = {};

set( handles.N, 'String', num2str( handles.Pop ) );
set( handles.R0, 'String', num2str( handles.R ) );
set( handles.n, 'String', num2str( handles.initInf ) );
set( handles.tau_inc, 'String', num2str( handles.t_inc ) );
% set( handles.tau_inf, 'String', num2str( handles.t_inf ) );
set( handles.tau_rec, 'String', num2str( handles.t_rec ) );
set( handles.simTime, 'String', num2str( 500 ) );

set( handles.Elderly, 'Value', handles.oldPop );
set( handles.ElderlyOut, 'String', sprintf( '%.0f%s', handles.oldPop*100, '%' ) );

set( handles.Recover, 'Value', handles.rRate );
set( handles.RecoverOut, 'String', sprintf( '%.0f%s', handles.rRate*100, '%' ) );

set( handles.ElderlyDeath, 'Value', handles.dOldRate );
set( handles.ElderlyDeathOut, 'String', sprintf( '%.0f%s', handles.dOldRate*100, '%' ) );

alphaStr = sprintf( '%.3f', handles.alpha );
gammaStr = sprintf( '%.3f', handles.gamma );
betaStr  = sprintf( '%.3f', handles.beta );
set( handles.Alpha, 'String', alphaStr );
set( handles.Gamma, 'String', gammaStr );
set( handles.Beta, 'String', betaStr );


handles.sigma = 0;
handles.t_sigmapre  = 0;
handles.t_sigmapost = 0;

set( handles.Sigma, 'Value', handles.sigma );
set( handles.SigmaOut, 'String', sprintf( '%.0f%s', handles.sigma*100, '%' ) );

set( handles.tau_sigmapre, 'String', num2str( handles.t_sigmapre ) );
set( handles.tau_sigmapost, 'String', num2str( handles.t_sigmapost ) );

handles.xi   = 0;
handles.t_xi = 0;
set( handles.Resusceptible, 'Value', handles.xi );
set( handles.ResusceptibleOut, 'String', sprintf( '%.2f%s', handles.xi, '%' ) );
set( handles.tau_xi, 'String', num2str( handles.t_xi ) );

handles.count       = 1;
handles.colourCount = 1;
handles.resetCount  = 2;

% Choose default command line output for covid
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes covid wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = covid_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function N_Callback(hObject, eventdata, handles)
% hObject    handle to N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N as text
%        str2double(get(hObject,'String')) returns contents of N as a double

% --- Executes during object creation, after setting all properties.
function N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function Elderly_Callback(hObject, eventdata, handles)
% hObject    handle to Elderly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Elderly = get( hObject, 'Value' );
set( handles.ElderlyOut, 'String', sprintf( '%.0f%s', Elderly*100, '%' ) );

% --- Executes during object creation, after setting all properties.
function Elderly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Elderly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Recover_Callback(hObject, eventdata, handles)
% hObject    handle to Recover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Recover = get( hObject, 'Value' );
set( handles.RecoverOut, 'String', sprintf( '%.0f%s', Recover*100, '%' ) );

% --- Executes during object creation, after setting all properties.
function Recover_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Recover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function ElderlyDeath_Callback(hObject, eventdata, handles)
% hObject    handle to ElderlyDeath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ElderlyDeath = get( hObject, 'Value' );
set( handles.ElderlyDeathOut, 'String', sprintf( '%.0f%s', ElderlyDeath*100, '%' ) );

% --- Executes during object creation, after setting all properties.
function ElderlyDeath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ElderlyDeath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function R0_Callback(hObject, eventdata, handles)
% hObject    handle to R0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R0 as text
%        str2double(get(hObject,'String')) returns contents of R0 as a double
handles.R = str2double( get( hObject, 'String' ) );
set( handles.Beta, 'String', num2str( handles.R / handles.t_rec ) );

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function R0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tau_inc_Callback(hObject, eventdata, handles)
% hObject    handle to tau_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau_inc as text
%        str2double(get(hObject,'String')) returns contents of tau_inc as a double
handles.t_inc = str2double( get( hObject, 'String' ) );
set( handles.Alpha, 'String', num2str( 1 / handles.t_inc ) );

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function tau_inc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tau_inf_Callback(hObject, eventdata, handles)
% hObject    handle to tau_inf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau_inf as text
%        str2double(get(hObject,'String')) returns contents of tau_inf as a double
% handles.t_inf = str2double( get( hObject, 'String' ) );

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function tau_inf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau_inf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tau_rec_Callback(hObject, eventdata, handles)
% hObject    handle to tau_rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau_rec as text
%        str2double(get(hObject,'String')) returns contents of tau_rec as a double
handles.t_rec = str2double( get( hObject, 'String' ) );
set( handles.Gamma, 'String', num2str( 1 / handles.t_rec ) );
set( handles.Beta, 'String', num2str( handles.R / handles.t_rec ) );

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function tau_rec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau_rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function n_Callback(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n as text
%        str2double(get(hObject,'String')) returns contents of n as a double

% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PB1.
function PB1_Callback(hObject, eventdata, handles)
% hObject    handle to PB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;

N       = str2double( get( handles.N, 'String' ) );
R0      = str2double( get( handles.R0, 'String' ) );
oldPop  = get( handles.Elderly, 'Value' );
otherPop= 1 - oldPop;

rRate   = get( handles.Recover, 'Value' );
dRate   = 1 - rRate;

dOldRate= get( handles.ElderlyDeath, 'Value' );
rOldRate= 1 - dOldRate;

n       = str2num( get( handles.n, 'String' ) );
tau_inc = str2double( get( handles.tau_inc, 'String' ) );
% tau_inf = str2double( get( handles.tau_inf, 'String' ) );
tau_rec = str2double( get( handles.tau_rec, 'String' ) );
simTime = str2double( get( handles.simTime, 'String' ) );

D_init  = 0;
R_init  = 0;
I_init  = n;
E_init  = 20 * I_init;
S_init  = N - I_init - E_init - D_init - R_init;

% D_init  = 53;
% R_init  = 759;
% I_init  = 1428; %n;
% E_init  = 880; %20 * I_init;
% S_init  = N - I_init - E_init - D_init - R_init;
% R0      = 2.75;

alpha   = 1 / tau_inc;
gamma   = 1 / tau_rec;
beta    = R0 * gamma;
delta   = gamma;

sigma = get( handles.Sigma, 'Value' )';
tau_sigmapre  = str2double( get( handles.tau_sigmapre, 'String' ) );
tau_sigmapost = str2double( get( handles.tau_sigmapost, 'String' ) );

xi     = get( handles.Resusceptible, 'Value' )/100;
tau_xi = str2double( get( handles.tau_xi, 'String' ) );

assignin( 'base', 'N', N );
assignin( 'base', 'n', n );
assignin( 'base', 'oldPop', oldPop );
assignin( 'base', 'otherPop', otherPop );
assignin( 'base', 'rRate', rRate );
assignin( 'base', 'dRate', dRate );
assignin( 'base', 'dOldRate', dOldRate );
assignin( 'base', 'rOldRate', rOldRate );
assignin( 'base', 'tau_inc', tau_inc );
% assignin( 'base', 'tau_inf', tau_inf );
assignin( 'base', 'tau_rec', tau_rec );
assignin( 'base', 'alpha', alpha );
assignin( 'base', 'gamma', gamma );
assignin( 'base', 'delta', delta );
assignin( 'base', 'beta', beta );
assignin( 'base', 'I_init', I_init );
assignin( 'base', 'E_init', E_init );
assignin( 'base', 'S_init', S_init );
assignin( 'base', 'D_init', D_init );
assignin( 'base', 'R_init', R_init );
assignin( 'base', 'sigma', sigma );
assignin( 'base', 'tau_sigmapre', tau_sigmapre );
assignin( 'base', 'tau_sigmapost', tau_sigmapost );
assignin( 'base', 'xi', xi );
assignin( 'base', 'tau_xi', tau_xi );


load_system( 'COVID_mod.mdl' );
out = sim( 'COVID_mod.mdl', simTime );
close_system( 'COVID_mod.mdl' );

assignin( 'base', 'out', out );

subplot( 1,1,1, 'Parent', handles.axes1 ); 
hold on;

colour = ['b'; 'r'; 'g'; 'y'; 'm'; 'c'];
if handles.colourCount > 6
    handles.colourCount = handles.colourCount - 6;
end

plot( out.I.Time+handles.firstCase, out.I.Data, 'Linewidth', 2 );
jbfill( [out.I.Time+handles.firstCase]', [out.IHi.Data]', [out.ILo.Data]', colour(handles.colourCount) );
plot( out.D.Time+handles.firstCase, out.D.Data, 'Linewidth', 2 );
jbfill( [out.D.Time+handles.firstCase]', [out.DHi.Data]', [out.DLo.Data]', colour(handles.colourCount+1) );
xlabel( 'Days' );
ylabel( 'Number of Cases' );
textStr = sprintf( '$$ \\begin{array}{l} R_0 = %.1f, \\beta = %.3f, \\alpha = %.3f, \\gamma = %.3f \\\\  N_{old} = %.0f\\%%, \\kappa = %.0f\\%%, (1-\\kappa)_{old} = %.0f\\%% \\\\ \\sigma = %.0f\\%%, \\tau_{pre-\\sigma} = %d, \\tau_{post-\\sigma} = %d, \\\\ \\xi = %.2f\\%%, \\tau_\\xi = %d \\end{array} $$',...
    R0, beta, alpha, gamma, oldPop*100, rRate*100, dOldRate*100, sigma*100, tau_sigmapre, tau_sigmapost, xi*100, tau_xi );
text( out.I.Time( find( out.I.Data == max( out.I.Data ) ) ) + 0.05*simTime, 0.95 * max( out.I.Data ), textStr, 'Interpreter', 'latex' );

handles.legendStr1{end+1,1} = sprintf( 'Infected, R_0 = %.1f (Model Case %d)', R0, handles.count );
handles.legendStr1{end+1,1} = sprintf( 'Infected, R_0 = %.1f\\pm5%% (Model Case %d)', R0, handles.count );
handles.legendStr1{end+1,1} = sprintf( 'Cum. Deaths, R_0 = %.1f (Model Case %d)', R0, handles.count );
handles.legendStr1{end+1,1} = sprintf( 'Cum. Deaths, R_0 = %.1f\\pm5%% (Model Case %d)', R0, handles.count );

legend( handles.legendStr1 );
grid on;
axis( [0 simTime -inf inf] );

if get( handles.stockData, 'Value' ) > 1
    subplot( 1,1,1, 'Parent', handles.axes2 );
    plot( out.I.Time+handles.firstCase, out.I.Data, 'Linewidth', 2 );
    jbfill( [out.I.Time+handles.firstCase]', [out.IHi.Data]', [out.ILo.Data]', colour(handles.colourCount) );
    plot( out.D.Time+handles.firstCase, out.D.Data, 'Linewidth', 2 );
    jbfill( [out.D.Time+handles.firstCase]', [out.DHi.Data]', [out.DLo.Data]', colour(handles.colourCount+1) );
%     plot( out.R, 'Linewidth', 2 );
    xlabel( 'Days' );
    ylabel( 'Number of Cases' );    
    title( ' ' );
    
    handles.legendStr2{end+1,1} = sprintf( 'Infected, R_0 = %.1f (Model Case %d)', R0, handles.count );
    handles.legendStr2{end+1,1} = sprintf( 'Infected, R_0 = %.1f\\pm5%% (Model Case %d)', R0, handles.count ); 
    handles.legendStr2{end+1,1} = sprintf( 'Cum. Deaths, R_0 = %.1f (Model Case %d)', R0, handles.count );
    handles.legendStr2{end+1,1} = sprintf( 'Cum. Deaths, R_0 = %.1f\\pm5%% (Model Case %d)', R0, handles.count ); 
    
    legend( handles.legendStr2 );
    axis( [0 handles.sizeData+10  0 handles.maxData*2] );
end

handles.count = handles.count + 1;
handles.colourCount = handles.colourCount + 2;

handles.resetCount = 0;


guidata( hObject, handles );




function simTime_Callback(hObject, eventdata, handles)
% hObject    handle to simTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simTime as text
%        str2double(get(hObject,'String')) returns contents of simTime as a double

% --- Executes during object creation, after setting all properties.
function simTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in CLA.
function CLA_Callback(hObject, eventdata, handles)
% hObject    handle to CLA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subplot( 1,1,1, 'Parent', handles.axes1 ); cla reset;
subplot( 1,1,1, 'Parent', handles.axes2 ); cla reset;
set( handles.stockData, 'Value', 1 );
handles.count = 1;
handles.colourCount = 1;
guidata(hObject, handles);
handles.legendStr1 = {};
handles.legendStr2 = {};

handles.resetCount = handles.resetCount + 1;

guidata( hObject, handles );




% --- Executes on selection change in stockData.
function stockData_Callback(hObject, eventdata, handles)
% hObject    handle to stockData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stockData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stockData
stockData = get( hObject, 'Value' );
if handles.resetCount >= 2
    if stockData == 2 % UK
        set( handles.N, 'String', '66000000' );
        set( handles.Elderly, 'Value', 0.18 );
        set( handles.ElderlyOut, 'String', '18%' );
        set( handles.Recover, 'Value', 0.90 );
        set( handles.RecoverOut, 'String', '90%' );
        set( handles.ElderlyDeath, 'Value', 0.20 );
        set( handles.ElderlyDeathOut, 'String', '20%' );
        set( handles.R0, 'String', '5.4' );
        set( handles.n, 'String', '2' );
        handles.firstCase = 10;
    elseif stockData == 3 % NI
        set( handles.N, 'String', '1880000' );
        set( handles.Elderly, 'Value', 0.18 );
        set( handles.ElderlyOut, 'String', '18%' );
        set( handles.Recover, 'Value', 0.94 );
        set( handles.RecoverOut, 'String', '94%' );
        set( handles.ElderlyDeath, 'Value', 0.12 );
        set( handles.ElderlyDeathOut, 'String', '12%' );
        set( handles.R0, 'String', '4.9' );
        set( handles.n, 'String', '3' );
        handles.firstCase = 9;
    elseif stockData == 4 % Italy
        set( handles.N, 'String', '60500000' );
        set( handles.Elderly, 'Value', 0.23 );
        set( handles.ElderlyOut, 'String', '23%' );
        set( handles.Recover, 'Value', 0.87 );
        set( handles.RecoverOut, 'String', '87%' );
        set( handles.ElderlyDeath, 'Value', 0.26 );
        set( handles.ElderlyDeathOut, 'String', '26%' );
        set( handles.R0, 'String', '6.4' );
        set( handles.n, 'String', '4' );
        handles.firstCase = 8;
    elseif stockData == 5 % South Korea
        set( handles.N, 'String', '51500000' );
        set( handles.Elderly, 'Value', 0.15 );
        set( handles.ElderlyOut, 'String', '15%' );
        set( handles.Recover, 'Value', 0.98 );
        set( handles.RecoverOut, 'String', '98%' );
        set( handles.ElderlyDeath, 'Value', 0.04 );
        set( handles.ElderlyDeathOut, 'String', '4%' );
        set( handles.R0, 'String', '5.1' );
        set( handles.n, 'String', '4' );
        handles.firstCase = 0;
    elseif stockData == 6 % Sweden
        set( handles.N, 'String', '10500000' );
        set( handles.Elderly, 'Value', 0.2 );
        set( handles.ElderlyOut, 'String', '20%' );
        set( handles.Recover, 'Value', 0.96 );
        set( handles.RecoverOut, 'String', '96%' );
        set( handles.ElderlyDeath, 'Value', 0.08 );
        set( handles.ElderlyDeathOut, 'String', '8%' );
        set( handles.R0, 'String', '3.8' );
        set( handles.n, 'String', '2' );
        handles.firstCase = 8;
    end
end
set( handles.Beta, 'String', num2str( sprintf( '%.3f', str2num( get( handles.R0, 'String' ) ) * str2num( get( handles.Gamma, 'String' ) ) ) ) );

if stockData > 1
    subplot( 1,1,1, 'Parent', handles.axes1 ); 
    hold on;
    
    country = handles.stockDataStr{stockData-1};

    if strcmp( country, 'NorthernIreland' )
        dataConfirmed = importdata( 'covid-19-totals-northern-ireland.csv' );
        yCases        = [dataConfirmed.data(:,2:3) zeros( size( dataConfirmed.data, 1 ),1 )];
        Date          = {dataConfirmed.textdata{:,1}};
    else
        dataConfirmed = importdata( 'time_series_covid19_confirmed_global.csv' );
        countryLoc    = find( strcmp( {dataConfirmed.textdata{:,2}}, country ) & strcmp( {dataConfirmed.textdata{:,1}}, '' ) );
        yCases        = dataConfirmed.data(countryLoc - 1, 3:end);
%         yConfirmedNew = dataConfirmed.data(countryLoc - 1, 3:end);
        
        dataDeaths = importdata( 'time_series_covid19_deaths_global.csv' );
        countryLoc = find( strcmp( {dataDeaths.textdata{:,2}}, country ) & strcmp( {dataDeaths.textdata{:,1}}, '' ) );
        yCases     = [yCases; dataDeaths.data(countryLoc - 1, 3:end)];
%         yDeathNew  = dataDeaths.data(countryLoc - 1, 3:end);
        
        dataRecovered  = importdata( 'time_series_covid19_recovered_global.csv' );
        countryLoc     = find( strcmp( {dataRecovered.textdata{:,2}}, country ) & strcmp( {dataRecovered.textdata{:,1}}, '' ) );
        yCases         = [yCases; [0 diff( dataRecovered.data(countryLoc - 1, 3:end) )]];
%         yRecoveredNew  = dataRecovered.data(countryLoc - 1, 3:end);
%         yRecoveredDiff = [0 diff( dataRecovered.data(countryLoc - 1, 3:end) )];
        
        yCases = yCases';
        Date   = {dataConfirmed.textdata{1,5:end}};
    end
    
    assignin( 'base', 'Infected', yCases(:,1) );
    assignin( 'base', 'Deaths', yCases(:,2) );
    if size( yCases, 2 ) == 3
        assignin( 'base', 'Recovered', yCases(:,3) );
    end
    assignin( 'base', 'Date', Date );
    
    plot( (1:length( yCases(:,1))), yCases(:,1), '*', 'Linewidth', 1 );
    plot( (1:length( yCases(:,2))), yCases(:,2), 'o', 'Linewidth', 1 );
    xlabel( 'Days' );
    ylabel( 'Number of Cases' );
    handles.legendStr1{end+1,1} = sprintf( 'Infected (%s)', country );
    handles.legendStr1{end+1,1} = sprintf( 'Cumulated Deaths (%s)', country );
    legend( handles.legendStr1 );
    axis( [0 inf 0 inf] );
    
    subplot( 1,1,1, 'Parent', handles.axes2 );
    hold on;
    plot( (1:length( yCases(:,1))), yCases(:,1) - yCases(:,3), '*', 'Linewidth', 1 );
    plot( (1:length( yCases(:,2))), yCases(:,2), 'o', 'Linewidth', 1 );
%     plot( (1:length( yCases(:,3)))-firstCase, yCases(:,3), '+', 'Linewidth', 1 );
    xlabel( 'Days' );
    ylabel( 'Number of Cases' );
    handles.legendStr2{end+1,1} = sprintf( 'Infected (%s)', country );
    handles.legendStr2{end+1,1} = sprintf( 'Cumulated Deaths (%s)', country );
%     handles.legendStr2{end+1,1} = sprintf( 'Recovered (%s)', country );
    leg2 = legend( handles.legendStr2 );
    leg2.Location = 'northwest';
    grid on;
    
    handles.maxData  = max( yCases(:,1) );
    handles.sizeData = length( yCases(:,1) );
    axis( [0 handles.sizeData+10  0 handles.maxData*2] );
end

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function stockData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stockData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Sigma_Callback(hObject, eventdata, handles)
% hObject    handle to Sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sigma = get( hObject, 'Value' );
set( handles.SigmaOut, 'String', sprintf( '%.0f%s', sigma*100, '%' ) );

% --- Executes during object creation, after setting all properties.
function Sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function tau_sigmapre_Callback(hObject, eventdata, handles)
% hObject    handle to tau_sigmapre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau_sigmapre as text
%        str2double(get(hObject,'String')) returns contents of tau_sigmapre as a double
handles.t_sigmapre = str2double( get( hObject, 'String' ) );

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function tau_sigmapre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau_sigmapre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tau_sigmapost_Callback(hObject, eventdata, handles)
% hObject    handle to tau_sigmapost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau_sigmapost as text
%        str2double(get(hObject,'String')) returns contents of tau_sigmapost as a double
handles.t_sigmapost = str2double( get( hObject, 'String' ) );

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function tau_sigmapost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau_sigmapost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Resusceptible_Callback(hObject, eventdata, handles)
% hObject    handle to Resusceptible (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Resusceptible = get( hObject, 'Value' );
set( handles.ResusceptibleOut, 'String', sprintf( '%.2f%s', Resusceptible, '%' ) );

% --- Executes during object creation, after setting all properties.
function Resusceptible_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Resusceptible (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function tau_xi_Callback(hObject, eventdata, handles)
% hObject    handle to tau_xi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau_xi as text
%        str2double(get(hObject,'String')) returns contents of tau_xi as a double
handles.t_xi = str2double( get( hObject, 'String' ) );

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function tau_xi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau_xi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotFigure.
function plotFigure_Callback(hObject, eventdata, handles)
% hObject    handle to plotFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% scrsz = get( 0,'ScreenSize' ); scrsz = scrsz(3:4);
plotHandle1 = figure;
existing   = findobj( handles.axes1, 'Type', 'axes' );
copyobj( existing, plotHandle1 );
legend( handles.legendStr1 );

plotHandle2 = figure;
existing   = findobj( handles.axes2, 'Type', 'axes' );
copyobj( existing, plotHandle2 );
legend( handles.legendStr2 );
