function S = GenStroke(im, width, dirNum)
% ==============================================
%   ��������ͼ 'S'
%  
%   Paras:
%   @im        : ����ͼ��
%   @width     : �ʻ����
%   @dirNum    : ������������
%
    
    %% �����趨
    [H, W, ~] = size(im);
    
    %% Smoothing
%     im = medfilt2(im, [3 3]);
    
    %% �ݶȴ�С
    [imX,imY]=gradient(im);
    imEdge = sqrt(imX.^2 + imY.^2);
    
    %% ˮƽ�����ϵľ����
    %��СΪͼ��߻��߿��1/30
    ks=floor(W/60);
    kerRef = zeros(ks*2+1);
    kerRef(ks+1,:) = 1;

    %% �ְ˸�������о��,�ۼ�ͬһ�����ϵ��ڽӵ� 
    response = zeros(H,W,dirNum);
    for n = 1 : dirNum
        ker = imrotate(kerRef, (n-1)*180/dirNum, 'bilinear', 'crop');
        response(:,:,n) = conv2(imEdge, ker, 'same');
    end
    [~, index] = max(response,[], 3); 

    %% ��ת����ֵӳ�䵽[0,1]���ɱʻ�
    C = zeros(H, W, dirNum);
    for n = 1 : dirNum
        C(:,:,n) = imEdge .* (index == n);
    end

    kerRef = zeros(ks*2+1);
    kerRef(ks+1,:) = 1;
    for n = 1 : width
        if (ks+1-n) > 0
            kerRef(ks+1-n,:) = 1;
        end
        if (ks+1+n) < (ks*2+1)
            kerRef(ks+1+n,:) = 1;
        end
    end
    
    Spn = zeros(H, W, dirNum);
    for n = 1 : dirNum
        ker = imrotate(kerRef, (n-1)*180/dirNum, 'bilinear', 'crop');
        Spn(:,:,n) = conv2(C(:,:,n), ker, 'same');
    end

    Sp = sum(Spn, 3);
    Sp = (Sp - min(Sp(:))) / (max(Sp(:)) - min(Sp(:)));
    S = 1 - Sp;
end