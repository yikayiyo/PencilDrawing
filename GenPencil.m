function T = GenPencil(im, P, J)
% ==============================================
%   生成素描纹理 'T'
%  
%   Paras:
%   @im        : 输入图像
%   @P         : 素描纹理
%   @J         : 色调图
%

    %% 参数设定
    lambda = 0.2;
    
    [H, W, ~] = size(im);

    %% 
    P = imresize(P, [H, W]);
    P = reshape(P, H*W, 1);
    logP = log(P);
    logP = spdiags(logP, 0, H*W, H*W);
    
    J = imresize(J, [H, W]);
    J = reshape(J, H*W, 1);
    logJ = log(J);
    
    e = ones(H*W, 1);
    Dx = spdiags([-e, e], [0, H], H*W, H*W);
    Dy = spdiags([-e, e], [0, 1], H*W, H*W);
    
    %% Compute matrix A and b
    A = lambda * (Dx * Dx' + Dy * Dy') + (logP)' * logP;
    b = (logP)' * logJ;
    
    %% 利用共轭梯度求解
    beta = pcg(A, b, 1e-6, 60);
    
    %% 计算结果
    beta = reshape(beta, H, W);   
    P = reshape(P, H, W);
    T = P .^ beta;
end