function varargout = concatCubesUI(varargin)
% CONCATCUBESUI M-file for concatCubesUI.fig
%      CONCATCUBESUI, by itself, creates a new CONCATCUBESUI or raises the existing
%      singleton*.
%
%      H = CONCATCUBESUI returns the handle to a new CONCATCUBESUI or the handle to
%      the existing singleton*.
%
%      CONCATCUBESUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONCATCUBESUI.M with the given input arguments.
%
%      CONCATCUBESUI('Property','Value',...) creates a new CONCATCUBESUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before concatCubesUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to concatCubesUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help concatCubesUI

% Last Modified by GUIDE v2.5 22-May-2017 16:57:29

% Begin initialization code - DO NOT EDIT

import mre_import.*;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @concatCubesUI_OpeningFcn, ...
    'gui_OutputFcn',  @concatCubesUI_OutputFcn, ...
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


% --- Executes just before concatCubesUI is made visible.
function concatCubesUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to concatCubesUI (see VARARGIN)

% Choose default command line output for concatCubesUI


handles.output = hObject;
handles.complexCubes=varargin{1};
handles.complexCubesOld=[];
handles=updateTable(handles);



% Update handles structure
guidata(hObject, handles);


% UIWAIT makes concatCubesUI wait for user response (see UIRESUME)
uiwait(handles.ConcatCubesUI);


% --- Outputs from this function are returned to the command line.
function varargout = concatCubesUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.complexCubes;
delete(handles.ConcatCubesUI);



% --- Executes on button press in proceedButton.
function proceedButton_Callback(hObject, eventdata, handles)
% hObject    handle to proceedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(handles.ConcatCubesUI, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.ConcatCubesUI);
end
% delete(handles.ConcatCubesUI);



% --- Executes on button press in dirConcatButton.
function dirConcatButton_Callback(hObject, eventdata, handles)
% hObject    handle to dirConcatButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dimension=5;
concatCube(hObject,handles,dimension);

% --- Executes on button press in concatFreqButton.
function concatFreqButton_Callback(hObject, eventdata, handles)
% hObject    handle to concatFreqButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dimension=6;
concatCube(hObject,handles,dimension);


% --- Executes on button press in undoButton.
function undoButton_Callback(hObject, eventdata, handles)
% hObject    handle to undoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.complexCubesOld)
    handles.complexCubes=handles.complexCubesOld;
    handles=updateTable(handles);
    % Update handles structure
    set(hObject,'Enable','off');
    guidata(hObject, handles);
    
end


function newHandles=updateTable(handles)
newHandles=handles;

complexCubes=handles.complexCubes;
tableContent=cell(length(complexCubes),8);
for index=1:length(complexCubes)
    currCube=complexCubes(index);
    tableContent(index,:)=cat(2,false,1,getCubeInfoCell( currCube ));
    
%     patientName=currCube.patientName;
%     seriesDescription=createSeriesDescriptionString(currCube.SeriesDescription);
%     studyDate=currCube.StudyDate;
%     acquisitionTimes=floor([currCube.ImageInfo(:).AcquisitionTime]);
%     timeString=[num2str(min(acquisitionTimes)) '-' num2str(max(acquisitionTimes)) ];
%     %     seriesTime=createSeriesDescriptionString({num2str(round(str2double([currCube.SeriesTime{:}])))});
%     cubeSizeString=createCubeSizeString(cubeSizeFormatString,currCube.cube);
%     
%     %     nrString=sprintf('%3.3s: ',num2str(index));
%     tableContent{index,1}=false;
%     tableContent{index,2}=mat2str(sort([complexCubes(index).SeriesNumber_magn complexCubes(index).SeriesNumber_phase]));
%     tableContent{index,3}=seriesDescription;
%     tableContent{index,4}=cubeSizeString;
%     tableContent{index,5}=timeString;
%     tableContent{index,6}=studyDate;
%     tableContent{index,7}=patientName;
%     
%     %     s=sprintf(formatString,...
%     %         nrString,seriesDescription,cubeSizeString,timeString,studyDate,patientName);
%     %     display([s '']);
%     %
end
set(newHandles.cubeTable,'Data',tableContent);


function descriptionString=createSeriesDescriptionString(seriesDescriptions)
uniqueDescriptions=unique(seriesDescriptions);
descriptionString=[];
for ind=1:(length(uniqueDescriptions)-1)
    descriptionString=[descriptionString uniqueDescriptions{ind} '; '];
end
descriptionString=[descriptionString uniqueDescriptions{end}];


function cubeSizeString=createCubeSizeString(formatString,cube)
cubeSizeString=sprintf(formatString,...
    num2str(size(cube,1)),num2str(size(cube,2)),num2str(size(cube,3)),...
    num2str(size(cube,4)),num2str(size(cube,5)),num2str(size(cube,6)),...
    num2str(size(cube,7)));


function concatCube(hObject,handles,dimension)
tmp_ComplexCubes=handles.complexCubes;
tableData=get(handles.cubeTable,'Data');
indices=find([tableData{:,1}]);
if length(indices)>1
    if checkDimensions(tmp_ComplexCubes(indices),dimension)
        tmp_ComplexCubes(min(indices))=concatComplexCubes( tmp_ComplexCubes(indices),dimension);
        selector=~[tableData{:,1}];
        selector(min(indices))=true;
        handles.complexCubesOld=handles.complexCubes;
        handles.complexCubes=tmp_ComplexCubes(selector);
        set(handles.undoButton,'Enable','on');
        %     guidata(hObject, handles);
        handles=updateTable(handles);
        guidata(hObject, handles);
    else
        warndlg('Dimension mismatch!');
    end
    
end

function ok=checkDimensions(cubes,dimension)
ok=true;
si=size(cubes(1).cube);
si(dimension)=1;
for index=1:length(cubes)
    si2=size(cubes(index).cube);
    si2(dimension)=1;
    if ~isequal(si,si2)
        ok=false;
        return;
    end
end



% --- Executes when user attempts to close ConcatCubesUI.
function ConcatCubesUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ConcatCubesUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes when selected cell(s) is changed in cubeTable.
function cubeTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to cubeTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in cubeTable.
function cubeTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to cubeTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% display(eventdata);
