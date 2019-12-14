%--------------------------------------------------------------------------
% File:         KAC_FourierSeries.m
% Description:  Uses a GUIDE tool to plot the components of a CTFourierSeries on 
%               four different axes. Can take any file that has time and 
%               value pairs and turn it into a fourier series.
% Author:       Kaleb Cox, kacox@ksu.edu,
%               (c)2018, Kansas State University. All rights reserved.
% Date:         15 October 2018
% Platform:     MATLAB R2018a (Version 9.4.0.813654), Windows 10 Enterprise
% Toolboxes:    N/A
% Revisions:    16 October 2018 - ADDED HEADER
%--------------------------------------------------------------------------

function varargout = KAC_FourierSeries(varargin)
% KAC_FourierSeries MATLAB code for KAC_FourierSeries.fig
%      KAC_FourierSeries, by itself, creates a new KAC_FourierSeries or raises the existing
%      singleton*.
%
%      H = KAC_FourierSeries returns the handle to a new KAC_FourierSeries or the handle to
%      the existing singleton*.
%
%      KAC_FourierSeries('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KAC_FourierSeries.M with the given input arguments.
%
%      KAC_FourierSeries('Property','Value',...) creates a new KAC_FourierSeries or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KAC_FourierSeries_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KAC_FourierSeries_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KAC_FourierSeries

% Last Modified by GUIDE v2.5 14-Dec-2019 15:01:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KAC_FourierSeries_OpeningFcn, ...
                   'gui_OutputFcn',  @KAC_FourierSeries_OutputFcn, ...
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


% --- Executes just before KAC_FourierSeries is made visible.
function KAC_FourierSeries_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KAC_FourierSeries (see VARARGIN)

% Choose default command line output for KAC_FourierSeries
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KAC_FourierSeries wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KAC_FourierSeries_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonParabola.
function buttonParabola_Callback(hObject, eventdata, handles)
% hObject    handle to buttonParabola (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = -pi:pi/64:pi;
a0 = (pi^2)/3;
n = 1:15;
aN = (2*(2*n*pi.*cos(n*pi)+(-2 + n.^2*pi^2).*sin(n*pi)))./(n.^3*pi);
bN = 0*n;
plotShit(a0,aN,bN,time,handles)


% --- Executes on button press in buttonSquare.
function buttonSquare_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSquare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = 0:.01:2;
a0=.5;
n = 1:30;
aN = (2*sin(pi*n/2))./(n*pi);
bN = 0*n;
plotShit(a0,aN,bN,time,handles)


% --- Executes on button press in buttonSawtooth.
function buttonSawtooth_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSawtooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = -pi:pi/64:pi;
a0=0;
n=1:30;
aN=0*n;
bN = (2*(sin(pi*n)-pi*n.*cos(pi*n)))./(pi*n.^2);
plotShit(a0,aN,bN,time,handles)


% --- Executes on button press in buttonExponential.
function buttonExponential_Callback(hObject, eventdata, handles)
% hObject    handle to buttonExponential (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = 0:.01:2;
a0=1/2*integral(@(x) exp(x),0,2);
for n=1:30
    aN(n)=integral(@(x) exp(x).*cos(n.*x.*pi),0,2);
    bN(n)=integral(@(x) exp(x).*sin(n*x.*pi),0,2);
end
plotShit(a0,aN,bN,time,handles)


% --- Executes on button press in buttonLoad.
function buttonLoad_Callback(hObject, eventdata, handles)
% hObject    handle to buttonLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uigetfile(('*.txt'));
file = load(filename);
time = file(:,1)';
value = file(:,2)';

a0 = sum(value)/(length(time));
dT = time(2)-time(1);
T0 = dT*(length(time)+1);
w0 = 2*pi/T0;

for n = 1:30
    aN(n) = sum(value(1:end-1).*cos(n.*w0.*time(1:end-1))+value(2:end).*cos(n.*w0.*time(2:end)))...
                    *2/T0*dT/2;
    bN(n) = sum(value(1:end-1).*sin(n.*w0.*time(1:end-1))+value(2:end).*sin(n.*w0.*time(2:end)))...
                    *2/T0*dT/2;
end
plotShit(a0,aN,bN,time,handles)



function plotShit(a0,aN,bN,time,handles)

cN = sqrt(aN.^2+bN.^2);
thetaN = atan2(-bN,aN);
T0 = (time(2)-time(1))*(length(time)+1);
w0 = 2*pi/T0;

plotTime = 0:(time(2)-time(1)):3*T0;
fN = ones(size(plotTime))*a0;

axes(handles.axes11);
cla
plot(plotTime, fN);
title("Components")
grid ON
hold on

axes(handles.axes21);
cla
scatter(0,a0);
line([0,0],[0,a0])
grid ON
title("Cn vs n")
hold on

axes(handles.axes12)
cla
plot(plotTime,fN)
title("Fourier series")
grid ON

axes(handles.axes22)
cla
scatter(0,atan2(0,a0));
line([0,0],[0,atan2(0,a0)])
grid ON
title("Theta vs n")
hold on

for n = 1:length(cN)
    pause(.2-n*.05)
    
    axes(handles.axes11)
    plot(plotTime, cN(n)*cos(n*w0*plotTime+thetaN(n)))
    hold on
    
    axes(handles.axes12)
    cla
    fN = fN + cN(n)*cos(n*w0*plotTime+thetaN(n));
    plot(plotTime,fN)
    title("Fourier series")
    grid ON

    axes(handles.axes21)
    scatter(n,cN(n))
    line([n,n],[0,cN(n)])
    hold on
    
    axes(handles.axes22)
    scatter(n,thetaN(n))
    line([n,n],[0,thetaN(n)])
    hold on
end


% --- Executes on button press in closeButton.
function closeButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(KAC_FourierSeries)
