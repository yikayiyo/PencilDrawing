function S = GenStroke(im, width, dirNum)
% ==============================================
%   生成轮廓图 'S'
%  
%   Paras:
%   @im        : 输入图像
%   @width     : 笔画宽度
%   @dirNum    : 卷积方向的数量
%
    
    %% 参数设定
    [H, W, ~] = size(im);
    
    %% Smoothing
%     im = medfilt2(im, [3 3]);
    
    %% 梯度大小
    [imX,imY]=gradient(im);
    imEdge = sqrt(imX.^2 + imY.^2);
    
    %% 水平方向上的卷积核
    %大小为图像高或者宽的1/30
    ks=floor(W/60);
    kerRef = zeros(ks*2+1);
    kerRef(ks+1,:) = 1;

    %% 分八个方向进行卷积,聚集同一方向上的邻接点 
    response = zeros(H,W,dirNum);
    for n = 1 : dirNum
        ker = imrotate(kerRef, (n-1)*180/dirNum, 'bilinear', 'crop');
        response(:,:,n) = conv2(imEdge, ker, 'same');
    end
    [~, index] = max(response,[], 3); 

    
    C = zeros(H, W, dirNum);
    for n = 1 : dirNum
        C(:,:,n) = imEdge .* (index == n);
    end

    %% 生成线条,反转像素值映射到[0,1]生成笔画
    Spn = zeros(H, W, dirNum);
    for n = 1 : dirNum
        ker = imrotate(kerRef, (n-1)*180/dirNum, 'bilinear', 'crop');
        Spn(:,:,n) = conv2(C(:,:,n), ker, 'same');
    end

    Sp = sum(Spn, 3);
    Sp = (Sp - min(Sp(:))) / (max(Sp(:)) - min(Sp(:)));
    S = 1 - Sp;
end
