function varargout = main(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_OpeningFcn, ...
    'gui_OutputFcn',  @main_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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

function main_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for main
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes main wait for user response (see UIRESUME) 
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%% 调节笔画宽度
function slider_strokewidth_Callback(hObject, eventdata, handles)
width=get(hObject,'Value')
set(handles.edit_strokewidth,'String',width);
btn_genstroke_Callback(hObject, eventdata, handles);
function slider_strokewidth_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% 生成轮廓
function btn_genstroke_Callback(hObject, eventdata, handles)
%获取笔画宽度
global im;global S;
width=get(handles.edit_strokewidth,'String');
width=str2double(width);
dark=get(handles.edit_strokedark,'String');
dark=str2double(dark);
im2 = im2double(im);
[H, W, sc] = size(im2);
%% RGB空间到YUV空间转换,提出Y通道进行处理
if (sc == 3)
    yuvIm = rgb2ycbcr(im2);
    lumIm = yuvIm(:,:,1);
else
    lumIm = im2;
end
S = GenStroke(lumIm, width, 8).^ dark;
% figure,imshow(S)
axes(handles.axes_stroke);
imshow(S);
axis off;

%% 生成结果图
function btn_genres_Callback(hObject, eventdata, handles)
global im;global J;global S;
val=get(handles.menu_texture,'Value');
switch val
    case 1
        path='pencils/pencil0.jpg';
    case 2
        path='pencils/pencil1.jpg';
    case 3
        path='pencils/pencil2.png';
    case 4
        path='pencils/pencil3.jpg';
    case 5
        path='pencils/pencil4.jpg';
end

im = im2double(im);
[H, W, sc] = size(im);
if (sc == 3)
    yuvIm = rgb2ycbcr(im);
    lumIm = yuvIm(:,:,1);
else
    lumIm = im;
end
P = im2double(imread(path));
P = rgb2gray(P);
T = GenPencil(lumIm, P, J);
lumIm = S .* T;
%Y通道处理完毕后放回,再转成RGB
if (sc == 3)
    yuvIm(:,:,1) = lumIm;
    I = ycbcr2rgb(yuvIm);
else
    I = lumIm;
end
axes(handles.axes_final);
imshow(I);
axis off;


%% 打开图片
function btn_load_Callback(hObject, eventdata, handles)
global im;
[filename,pathname]=uigetfile({'*.jpg;*.png;*.tif;*.*;'},'读入照片');
filepath=strcat(pathname,filename);
if filepath~=0
    set(handles.edit_filename,'String',filepath);
    im=imread(filepath);
    %     figure,imshow(im);
    axes(handles.axes_load);
    image(im);
    axis off;
end



function edit_filename_Callback(hObject, eventdata, handles)

function edit_filename_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% 调节笔画深度
function slider_strokedark_Callback(hObject, eventdata, handles);
dark=get(hObject,'Value');
set(handles.edit_strokedark,'String',dark);
btn_genstroke_Callback(hObject, eventdata, handles)
function slider_strokedark_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% 生成色调
function btn_gentone_Callback(hObject, eventdata, handles)
tonedark=get(handles.edit_tonedark,'String');
tonedark=str2double(tonedark);
global im;
global J;
im3 = im2double(im);
[H, W, sc] = size(im3);
if (sc == 3)
    yuvIm = rgb2ycbcr(im3);
    lumIm = yuvIm(:,:,1);
else
    lumIm = im3;
end
J = GenToneMap(lumIm) .^ tonedark;
axes(handles.axes_tone);
imshow(J);
axis off;

function edit_strokedark_Callback(hObject, eventdata, handles)
function edit_strokedark_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_strokewidth_Callback(hObject, eventdata, handles)
function edit_strokewidth_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function menu_texture_Callback(hObject, eventdata, handles)
global val;
val=get(handles.menu_texture,'Value');

function menu_texture_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function btn_save_Callback(hObject, eventdata, handles)
[filename,pathname]=uiputfile({'*.jpg'},'保存文件');
if filename~=0
    path=strcat(pathname,filename);
    pix=getframe(handles.axes_final);
    imwrite(pix.cdata,path,'jpg')
end

%% 调节色调深度
function slider_tonedark_Callback(hObject, eventdata, handles)
tonedark=get(hObject,'Value')
set(handles.edit_tonedark,'String',tonedark);
btn_gentone_Callback(hObject, eventdata, handles);

function slider_tonedark_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_tonedark_Callback(hObject, eventdata, handles)
function edit_tonedark_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function axes_stroke_CreateFcn(hObject, eventdata, handles)
