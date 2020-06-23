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

% Last Modified by GUIDE v2.5 22-Jun-2020 15:18:20

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
persistent fontSizeDecreased
fontSizeDecreased = [];
if ~ismac( )
    % No MAC OSX detected; decrease font sizes
    if isempty( fontSizeDecreased )
        for afield = fieldnames(handles)'
            afield = afield{1};
            try
                set( handles.(afield),'FontSize',get( handles.(afield),'FontSize' ) * 0.75 );
            end
        end
        fontSizeDecreased = 1; % do not perform this step again.
    end
end

clc;

address = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv';
websave( 'time_series_covid19_confirmed_global.csv', address );
address = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv';
websave( 'time_series_covid19_deaths_global.csv', address );
address = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv';
websave( 'time_series_covid19_recovered_global.csv', address );
address = 'https://raw.githubusercontent.com/tomwhite/covid-19-uk-data/master/data/covid-19-totals-northern-ireland.csv';
websave( 'covid-19-totals-northern-ireland.csv', address );

set( handles.stockData, 'Value', 1 );
handles.stockDataStr = {'United Kingdom', 'NorthernIreland', 'Italy', 'Korea, South', 'Sweden', 'Malaysia'};
handles.legendStr1 = {};
handles.legendStr2 = {};

set( handles.N, 'String', num2str( 1000000 ) );
set( handles.R0, 'String', num2str( 2.5 ) );
set( handles.n, 'String', num2str( 5 ) );
set( handles.tau_inc, 'String', num2str( 5.1 ) );
set( handles.tau_rec, 'String', num2str( 18.8 ) );
set( handles.simTime, 'String', num2str( 500 ) );

set( handles.Elderly, 'Value', 0.15 );
set( handles.ElderlyOut, 'String', sprintf( '%.0f%s', 15, '%' ) );

set( handles.Recover, 'Value', 0.9 );
set( handles.RecoverOut, 'String', sprintf( '%.0f%s', 90, '%' ) );

set( handles.ElderlyDeath, 'Value', 0.15 );
set( handles.ElderlyDeathOut, 'String', sprintf( '%.0f%s', 15, '%' ) );

Delta = (1/18.8) * (0.15*0.15 + 0.1*0.85 );
alphaStr = sprintf( '%.2f', 1/5.1 );
gammaStr = sprintf( '%.2f', 1/18.8);
betaStr  = sprintf( '%.2f', 2.5 * ((1/18.8) + Delta ) );
set( handles.Alpha, 'String', alphaStr );
set( handles.Gamma, 'String', gammaStr );
set( handles.Beta, 'String', betaStr );

set( handles.Sigma, 'Value', 0 );
set( handles.SigmaOut, 'String', sprintf( '%.0f%s', 0, '%' ) );

set( handles.tau_sigmapre, 'String', num2str( 0 ) );
set( handles.tau_sigmapost, 'String', num2str( 0 ) );

set( handles.Resusceptible, 'Value', 0 );
set( handles.ResusceptibleOut, 'String', sprintf( '%.2f%s', 0, '%' ) );
set( handles.tau_xi, 'String', num2str( 0 ) );

handles.firstCase   = 0;
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
% Get default command line output from handles structure
varargout{1} = handles.output;

function N_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function N_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function Elderly_Callback(hObject, eventdata, handles)
Elderly = get( hObject, 'Value' );
set( handles.ElderlyOut, 'String', sprintf( '%.0f%s', Elderly*100, '%' ) );

% --- Executes during object creation, after setting all properties.
function Elderly_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Recover_Callback(hObject, eventdata, handles)
Recover = get( hObject, 'Value' );
set( handles.RecoverOut, 'String', sprintf( '%.0f%s', Recover*100, '%' ) );

% --- Executes during object creation, after setting all properties.
function Recover_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function ElderlyDeath_Callback(hObject, eventdata, handles)
ElderlyDeath = get( hObject, 'Value' );
set( handles.ElderlyDeathOut, 'String', sprintf( '%.0f%s', ElderlyDeath*100, '%' ) );

% --- Executes during object creation, after setting all properties.
function ElderlyDeath_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function R0_Callback(hObject, eventdata, handles)
R        = str2double( get( handles.R0, 'String' ) );
gamma    = 1/str2double( get( handles.tau_rec, 'String' ) );
dOldRate = get( handles.ElderlyDeath, 'Value' );
oldPop   = get( handles.Elderly, 'Value' );
dRate    = 1 - get( handles.Recover, 'Value' );
sigma    = get( handles.Sigma, 'Value' );

Delta = gamma * (dOldRate*oldPop + dRate*(1-oldPop));
beta  = R * (gamma + Delta);
set( handles.Beta, 'String', sprintf( '%0.2f', beta ) );
guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function R0_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tau_inc_Callback(hObject, eventdata, handles)
alpha = 1/str2double( get( handles.tau_inc, 'String' ) );
set( handles.Alpha, 'String', sprintf( '%0.2f', alpha ) );
guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function tau_inc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tau_rec_Callback(hObject, eventdata, handles)
R        = str2double( get( handles.R0, 'String' ) );
gamma    = 1/str2double( get( handles.tau_rec, 'String' ) );
dOldRate = get( handles.ElderlyDeath, 'Value' );
oldPop   = get( handles.Elderly, 'Value' );
dRate    = 1 - get( handles.Recover, 'Value' );
sigma    = get( handles.Sigma, 'Value' );

Delta = gamma * (dOldRate*oldPop + dRate*(1-oldPop));
beta  = R * (gamma + Delta);
set( handles.Beta, 'String', sprintf( '%0.2f', beta ) );
set( handles.Gamma, 'String', sprintf( '%0.2f', gamma ) );
guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function tau_rec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function n_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PB1.
function PB1_Callback(hObject, eventdata, handles)
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
alpha   = 1 / str2double( get( handles.tau_inc, 'String' ) );
gamma   = 1 / str2double( get( handles.tau_rec, 'String' ) );
sigma   = get( handles.Sigma, 'Value' );
simTime = str2double( get( handles.simTime, 'String' ) );

delta   = gamma;
Delta   = delta * ( dOldRate*oldPop + dRate*otherPop );
beta    = R0 * (gamma + Delta);

tau_sigmapre  = str2double( get( handles.tau_sigmapre, 'String' ) );
tau_sigmapost = str2double( get( handles.tau_sigmapost, 'String' ) );

xi     = get( handles.Resusceptible, 'Value' ) / 100;
tau_xi = str2double( get( handles.tau_xi, 'String' ) );

tol = 0.05;
Hi  = 1 + tol;
Lo  = 1 - tol;

D_init  = 0;
R_init  = 0;
I_init  = n;
E_init  = 20 * I_init;
S_init  = N - I_init - E_init - D_init - R_init;

% % NISA
% D_init  = 84.2034;
% R_init  = 772.5085;
% I_init  = 1.4594e+03;
% E_init  = 915.6255; %20 * I_init;
% S_init  = N - I_init - E_init - D_init - R_init;
% R0      = 2.9; %2.805;
% load NINew;

% % KoreaSA
% I_init = 7.2662e+03;
% D_init = 143.8303;
% R_init = 6.2535e+03;
% E_init = 1.7200e+03;
% S_init  = N - I_init - E_init - D_init - R_init;
% R0      = 0.612;
% load Korea1;
% subplot( 1,1,1, 'Parent', handles.axes1 );
% hold on;
% plot( out.I.Time(1:54), out.I.Data(1:54), 'Linewidth', 3 );
% subplot( 1,1,1, 'Parent', handles.axes2 );
% hold on;
% plot( out.I.Time(1:54), out.I.Data(1:54), 'Linewidth', 3 );

assignin( 'base', 'N', N );
assignin( 'base', 'n', n );
assignin( 'base', 'oldPop', oldPop );
assignin( 'base', 'otherPop', otherPop );
assignin( 'base', 'rRate', rRate );
assignin( 'base', 'dRate', dRate );
assignin( 'base', 'dOldRate', dOldRate );
assignin( 'base', 'rOldRate', rOldRate );
assignin( 'base', 'Hi', Hi );
assignin( 'base', 'Lo', Lo );
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
% colour = get( gca, 'ColorOrder' );
if handles.colourCount > size( colour, 1 )
    handles.colourCount = handles.colourCount - size( colour, 1 );
end

plot( out.I.Time+handles.firstCase, out.I.Data, 'Linewidth', 3 );
jbfill( [out.I.Time+handles.firstCase]', [out.IHi.Data]', [out.ILo.Data]', colour(handles.colourCount) );
plot( out.D.Time+handles.firstCase, out.D.Data, 'Linewidth', 3 );
jbfill( [out.D.Time+handles.firstCase]', [out.DHi.Data]', [out.DLo.Data]', colour(handles.colourCount+1) );
xlabel( 'Days' );
ylabel( 'Number of Cases' );
if sigma == 0
    textStr = sprintf( '$$ \\begin{array}{l} R_0 = %.1f, \\beta = %.2f, \\alpha = %.2f, \\gamma = %.2f \\\\  N_{old} = %.0f\\%%, \\kappa = %.0f\\%%, (1-\\kappa)_{old} = %.0f\\%% \\\\ \\sigma = %.0f\\%%, \\tau_{pre-\\sigma} = %d, \\tau_{post-\\sigma} = %d, \\\\ \\xi = %.2f\\%%, \\tau_\\xi = %d \\end{array} $$',...
    R0, beta, alpha, gamma, oldPop*100, rRate*100, dOldRate*100, sigma*100, tau_sigmapre, tau_sigmapost, xi*100, tau_xi );
else
    textStr = sprintf( '$$ \\begin{array}{l} R_0 = %.1f, \\beta = %.2f, \\alpha = %.2f, \\gamma = %.2f \\\\  N_{old} = %.0f\\%%, \\kappa = %.0f\\%%, (1-\\kappa)_{old} = %.0f\\%% \\\\ \\sigma = %.0f\\%%, \\tau_{pre-\\sigma} = %d, \\tau_{post-\\sigma} = %d, \\\\ \\xi = %.2f\\%%, \\tau_\\xi = %d \\\\ \\mbox{Post-control } R_0 = %.2f \\end{array} $$',...
    R0, beta, alpha, gamma, oldPop*100, rRate*100, dOldRate*100, sigma*100, tau_sigmapre, tau_sigmapost, xi*100, tau_xi, R0 * (1 - sigma) );
end
text( out.I.Time( find( out.I.Data == max( out.I.Data ) ) ) + 0.05*simTime, 0.9 * max( out.I.Data ), textStr, 'Interpreter', 'latex', 'FontSize', 14 );

handles.legendStr1{end+1,1} = sprintf( 'Infected, R_0 = %.1f (Model Case %d)', R0, handles.count );
handles.legendStr1{end+1,1} = sprintf( 'Infected, R_0 = %.1f (95%% CI) (Model Case %d)', R0, handles.count );
handles.legendStr1{end+1,1} = sprintf( 'Cum. Deaths, R_0 = %.1f (Model Case %d)', R0, handles.count );
handles.legendStr1{end+1,1} = sprintf( 'Cum. Deaths, R_0 = %.1f (95%% CI) (Model Case %d)', R0, handles.count );

legend( handles.legendStr1 );
grid on;
% axis( [-inf simTime -inf inf] );
xlim( [0 simTime] );

if get( handles.stockData, 'Value' ) > 1
    subplot( 1,1,1, 'Parent', handles.axes2 );
    plot( out.I.Time+handles.firstCase, out.I.Data, 'Linewidth', 3 );
    jbfill( [out.I.Time+handles.firstCase]', [out.IHi.Data]', [out.ILo.Data]', colour(handles.colourCount) );
    plot( out.D.Time+handles.firstCase, out.D.Data, 'Linewidth', 3 );
    jbfill( [out.D.Time+handles.firstCase]', [out.DHi.Data]', [out.DLo.Data]', colour(handles.colourCount+1) );
    xlabel( 'Days' );
    ylabel( 'Number of Cases' );
    title( ' ' );
    
    handles.legendStr2{end+1,1} = sprintf( 'Infected, R_0 = %.1f (Model Case %d)', R0, handles.count );
    handles.legendStr2{end+1,1} = sprintf( 'Infected, R_0 = %.1f (95%% CI) (Model Case %d)', R0, handles.count );
    handles.legendStr2{end+1,1} = sprintf( 'Cum. Deaths, R_0 = %.1f (Model Case %d)', R0, handles.count );
    handles.legendStr2{end+1,1} = sprintf( 'Cum. Deaths, R_0 = %.1f (95%% CI) (Model Case %d)', R0, handles.count );
    
    legend( handles.legendStr2 );
    axis( [-inf handles.sizeData+10  0 handles.maxData*1.5] );
end

handles.count = handles.count + 1;
handles.colourCount = handles.colourCount + 2;
handles.resetCount = 0;
guidata( hObject, handles );


function simTime_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function simTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CLA.
function CLA_Callback(hObject, eventdata, handles)
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
        set( handles.Recover, 'Value', 0.89 );
        set( handles.RecoverOut, 'String', '89%' );
        set( handles.ElderlyDeath, 'Value', 0.12 );
        set( handles.ElderlyDeathOut, 'String', '12%' );
        set( handles.R0, 'String', '5' );
        set( handles.n, 'String', '3' );
        handles.tol = 0.05;
        handles.firstCase = 6;
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
        handles.tol = 0.05;
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
    elseif stockData == 7 % Malaysia
        set( handles.N, 'String', '32000000' );
        set( handles.Elderly, 'Value', 0.065 );
        set( handles.ElderlyOut, 'String', '65%' );
        set( handles.Recover, 'Value', 0.98 );
        set( handles.RecoverOut, 'String', '98%' );
        set( handles.ElderlyDeath, 'Value', 0.05 );
        set( handles.ElderlyDeathOut, 'String', '5%' );
        set( handles.R0, 'String', '3.8' );
        set( handles.n, 'String', '2' );
        handles.firstCase = 3;
    end
end

R        = str2double( get( handles.R0, 'String' ) );
gamma    = 1/str2double( get( handles.tau_rec, 'String' ) );
dOldRate = get( handles.ElderlyDeath, 'Value' );
oldPop   = get( handles.Elderly, 'Value' );
dRate    = 1 - get( handles.Recover, 'Value' );
sigma    = get( handles.Sigma, 'Value' );

Delta = gamma * (dOldRate*oldPop + dRate*(1-oldPop));
beta  = R * (gamma + Delta);
set( handles.Beta, 'String', sprintf( '%0.2f', beta ) );
set( handles.Gamma, 'String', sprintf( '%0.2f', gamma ) );


if stockData > 1
    subplot( 1,1,1, 'Parent', handles.axes1 );
    hold on;
    
    country = handles.stockDataStr{stockData-1};
    
    if strcmp( country, 'NorthernIreland' )
        dataConfirmed = importdata( 'covid-19-totals-northern-ireland.csv' );
%         dataConfirmed = importdata( 'NI.csv' );
        yCases        = [dataConfirmed.data(24:end,2:3) zeros( size( dataConfirmed.data, 1 )-23,1 )];
        Date          = {dataConfirmed.textdata{24:end,1}};
    else
        dataConfirmed = importdata( 'time_series_covid19_confirmed_global.csv' );
        countryLoc    = find( strcmp( {dataConfirmed.textdata{:,2}}, country ) & strcmp( {dataConfirmed.textdata{:,1}}, '' ) );
        yCases        = dataConfirmed.data(countryLoc - 1, 3:end);
        
        dataDeaths = importdata( 'time_series_covid19_deaths_global.csv' );
        countryLoc = find( strcmp( {dataDeaths.textdata{:,2}}, country ) & strcmp( {dataDeaths.textdata{:,1}}, '' ) );
        yCases     = [yCases; dataDeaths.data(countryLoc - 1, 3:end)];
        
        dataRecovered  = importdata( 'time_series_covid19_recovered_global.csv' );
        countryLoc     = find( strcmp( {dataRecovered.textdata{:,2}}, country ) & strcmp( {dataRecovered.textdata{:,1}}, '' ) );
        yCases         = [yCases; [( dataRecovered.data(countryLoc - 1, 3:end) )]];
        
        yCases = yCases';
        Date   = {dataConfirmed.textdata{1,5:end}};
    end
    
    assignin( 'base', 'Infected', ( yCases(:,1) ) );
    assignin( 'base', 'Deaths', yCases(:,2) );
    if size( yCases, 2 ) == 3
        assignin( 'base', 'Recovered', yCases(:,3) );
    end
    assignin( 'base', 'Date', Date );
    
    plot( (1:length( yCases(:,1))), ( yCases(:,1) - yCases(:,3) - yCases(:,2) ), '*', 'Linewidth', 1 );
    plot( (1:length( yCases(:,2))), yCases(:,2), 'o', 'Linewidth', 1 );
    xlabel( 'Days' );
    ylabel( 'Number of Cases' );
    handles.legendStr1{end+1,1} = sprintf( 'Infected (%s)', country );
    handles.legendStr1{end+1,1} = sprintf( 'Cumulated Deaths (%s)', country );
    legend( handles.legendStr1 );
    axis( [-inf inf 0 inf] );
    
    subplot( 1,1,1, 'Parent', handles.axes2 );
    hold on;
    plot( (1:length( yCases(:,1))), ( yCases(:,1) - yCases(:,3) - yCases(:,2) ), '*', 'Linewidth', 1 );
    plot( (1:length( yCases(:,2))), yCases(:,2), 'o', 'Linewidth', 1 );
    xlabel( 'Days' );
    ylabel( 'Number of Cases' );
    handles.legendStr2{end+1,1} = sprintf( 'Infected (%s)', country );
    handles.legendStr2{end+1,1} = sprintf( 'Cumulated Deaths (%s)', country );
    leg2 = legend( handles.legendStr2 );
    leg2.Location = 'northwest';
    grid on;
    
    handles.maxData  = max( yCases(:,1) );
    handles.sizeData = length( yCases(:,1) );
    axis( [-inf handles.sizeData+10  0 handles.maxData*1.5] );
end

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function stockData_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Sigma_Callback(hObject, eventdata, handles)
sigma = get( hObject, 'Value' );
set( handles.SigmaOut, 'String', sprintf( '%.0f%s', sigma*100, '%' ) );

R        = str2double( get( handles.R0, 'String' ) );
gamma    = 1/str2double( get( handles.tau_rec, 'String' ) );
dOldRate = get( handles.ElderlyDeath, 'Value' );
oldPop   = get( handles.Elderly, 'Value' );
dRate    = 1 - get( handles.Recover, 'Value' );

Delta = gamma * (dOldRate*oldPop + dRate*(1-oldPop));
beta  = R * (gamma + Delta);
set( handles.Beta, 'String', sprintf( '%0.2f', beta ) );
set( handles.Gamma, 'String', sprintf( '%0.2f', gamma ) );

% --- Executes during object creation, after setting all properties.
function Sigma_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function tau_sigmapre_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function tau_sigmapre_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tau_sigmapost_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function tau_sigmapost_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Resusceptible_Callback(hObject, eventdata, handles)
Resusceptible = get( hObject, 'Value' );
set( handles.ResusceptibleOut, 'String', sprintf( '%.2f%s', Resusceptible, '%' ) );

% --- Executes during object creation, after setting all properties.
function Resusceptible_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function tau_xi_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function tau_xi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotFigure.
function plotFigure_Callback(hObject, eventdata, handles)
scrsz       = get( 0,'ScreenSize' ); scrsz = scrsz(3:4);
plotHandle1 = figure;
existing    = findobj( handles.axes2, 'Type', 'axes' );
copyobj( existing, plotHandle1 );
set( gca, 'fontsize', 14 );

legend( handles.legendStr1, 'Location', 'northoutside' );

plotHandle2 = figure;
existing    = findobj( handles.axes1, 'Type', 'axes' );
copyobj( existing, plotHandle2 );
legend( handles.legendStr2, 'Location', 'Northoutside' );
set( gca, 'fontsize', 14 );


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when axes1 is resized.
function axes1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
