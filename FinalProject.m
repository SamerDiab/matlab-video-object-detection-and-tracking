function varargout = FinalProject(varargin)
% FINALPROJECT MATLAB code for FinalProject.fig
%      FINALPROJECT, by itself, creates a new FINALPROJECT or raises the existing
%      singleton*.
%
%      H = FINALPROJECT returns the handle to a new FINALPROJECT or the handle to
%      the existing singleton*.
%
%      FINALPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALPROJECT.M with the given input arguments.
%
%      FINALPROJECT('Property','Value',...) creates a new FINALPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FinalProject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FinalProject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FinalProject

% Last Modified by GUIDE v2.5 22-May-2018 15:16:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FinalProject_OpeningFcn, ...
    'gui_OutputFcn',  @FinalProject_OutputFcn, ...
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


% --- Executes just before FinalProject is made visible.
function FinalProject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FinalProject (see VARARGIN)

% Choose default command line output for FinalProject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FinalProject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FinalProject_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)


baseImage = rgb2gray(imread('base.png'));
basePoints = detectSURFFeatures(baseImage);

[baseFeatures, basePoints] = extractFeatures(baseImage, basePoints);

figure('Position',[10000,10000,400,300]);
imshow(baseImage);
title('Our Base Image');
hold on;
plot(selectStrongest(basePoints, 8000));

  vidObj = VideoReader('vid.mp4');
    numFrames = 0;
    while hasFrame(vidObj)
        readFrame(vidObj);
        numFrames = numFrames + 1;
    end
    
vid=VideoReader('vid.mp4');


for iFrame = 1:numFrames
    frames = read(vid, iFrame);
    sceneImage = rgb2gray(frames);
    
    
    scenePoints = detectSURFFeatures(sceneImage);
    
    
    %figure;
    %imshow(sceneImage);
   % hold on;
   % plot(selectStrongest(scenePoints, 8000));
    
    
    
    [sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);
    
    basePairs = matchFeatures(baseFeatures, sceneFeatures);
    
    matchedBasePoints = basePoints(basePairs(:, 1), :);
    matchedScenePoints = scenePoints(basePairs(:, 2), :);
    
    
    
    try
        tform = estimateGeometricTransform(matchedBasePoints, matchedScenePoints, 'similarity');
    catch
        
        
    end
    basePolygon = [1, 1;...                           % top-lef
        size(baseImage, 2), 1;...                 % top-right
        size(baseImage, 2), size(baseImage, 1);... % bottom-right
        1, size(baseImage, 1);...                 % bottom-left
        1, 1];
    
    
    newBasePolygon = transformPointsForward(tform, basePolygon);
    

    hold on;
    
  
    imshow(sceneImage, 'Parent', handles.axes1);
    hold on;
    
    line(handles.axes1,newBasePolygon(:, 1), newBasePolygon(:, 2), 'Color', 'y');
    
    pause(0.12);
end

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
