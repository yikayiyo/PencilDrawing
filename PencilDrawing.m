function I = PencilDrawing(im, width, dirNum, gammaS, gammaI)
% ==============================================
%   Generate the pencil drawing I based on the method described in
%   "Combining Sketch and Tone for Pencil Drawing Production" Cewu Lu, Li Xu, Jiaya Jia 
%   International Symposium on Non-Photorealistic Animation and Rendering (NPAR 2012), June, 2012
%  
%   Paras:
%   @im        : 输入图像
%   @width     : 笔画宽度
%   @dirNum    : 卷积方向数量
%   @gammaS    : 笔画颜色深度
%   @gammaI    : 生成图的暗度
%

    %% 读入图片
    im = im2double(im);
    [H, W, sc] = size(im);

    %% RGB空间到YUV空间转换,提出Y通道进行处理
    if (sc == 3)
        yuvIm = rgb2ycbcr(im);
        lumIm = yuvIm(:,:,1);
    else
        lumIm = im;
    end

    %% 生成轮廓图
    S = GenStroke(lumIm, width, dirNum) .^ gammaS; % gamma加深笔画
%     figure, imshow(S)

    %% 生成色调图
    J = GenToneMap(lumIm) .^ gammaI; % gamma加深色调
%     figure, imshow(J)

    %% 生成素描纹理
    P = im2double(imread('pencils/pencil1.jpg'));
    P = rgb2gray(P);
    T = GenPencil(lumIm, P, J);
%     figure, imshow(T)

    %% 点乘结合
    lumIm = S .* T;
    %Y通道处理完毕后放回,再转成RGB
    if (sc == 3)
        yuvIm(:,:,1) = lumIm;
        I = ycbcr2rgb(yuvIm);
    else
        I = lumIm;
    end
end

