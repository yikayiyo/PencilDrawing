function I = PencilDrawing(im, width, dirNum, gammaS, gammaI)
% ==============================================
%   Generate the pencil drawing I based on the method described in
%   "Combining Sketch and Tone for Pencil Drawing Production" Cewu Lu, Li Xu, Jiaya Jia 
%   International Symposium on Non-Photorealistic Animation and Rendering (NPAR 2012), June, 2012
%  
%   Paras:
%   @im        : ����ͼ��
%   @width     : �ʻ����
%   @dirNum    : �����������
%   @gammaS    : �ʻ���ɫ���
%   @gammaI    : ����ͼ�İ���
%

    %% ����ͼƬ
    im = im2double(im);
    [H, W, sc] = size(im);

    %% RGB�ռ䵽YUV�ռ�ת��,���Yͨ�����д���
    if (sc == 3)
        yuvIm = rgb2ycbcr(im);
        lumIm = yuvIm(:,:,1);
    else
        lumIm = im;
    end

    %% ��������ͼ
    S = GenStroke(lumIm, width, dirNum) .^ gammaS; % gamma����ʻ�
%     figure, imshow(S)

    %% ����ɫ��ͼ
    J = GenToneMap(lumIm) .^ gammaI; % gamma����ɫ��
%     figure, imshow(J)

    %% ������������
    P = im2double(imread('pencils/pencil1.jpg'));
    P = rgb2gray(P);
    T = GenPencil(lumIm, P, J);
%     figure, imshow(T)

    %% ��˽��
    lumIm = S .* T;
    %Yͨ��������Ϻ�Ż�,��ת��RGB
    if (sc == 3)
        yuvIm(:,:,1) = lumIm;
        I = ycbcr2rgb(yuvIm);
    else
        I = lumIm;
    end
end

