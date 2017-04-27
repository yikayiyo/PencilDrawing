function J = GenToneMap(im)
% ==============================================
%   ����ɫ��ͼ 'T'
%  
%   Paras:
%   @im        : ����ͼ��
%
    
    %% �趨����
    Ub = 225;
    Ua = 105;
    
    Mud = 90;
    
    DeltaB = 9;
    DeltaD = 11;
    
    % groups from dark to light
    % 1st group

%     Omega1 = 42;
%     Omega2 = 29;
%     Omega3 = 29;
    % 2nd group
%     Omega1 = 52;
%     Omega2 = 37;
%     Omega3 = 11;

    % 3rd group
    Omega1 = 76;
    Omega2 = 22;
    Omega3 = 2;
    
    %% �����Ŀ��ֱ��ͼ
    histgramTarget = zeros(256, 1);
    total = 0;
    for ii = 0 : 255
        if ii < Ua || ii > Ub
            p = 0;
        else
            p = 1 / (Ub - Ua);
        end
        
        histgramTarget(ii+1, 1) = (...
            Omega1 * 1/DeltaB * exp(-(255-ii)/DeltaB) + ...
            Omega2 * p + ...
            Omega3 * 1/sqrt(2 * pi * DeltaD) * exp(-(ii-Mud)^2/(2*DeltaD^2))) * 0.01;
        
        total = total + histgramTarget(ii+1, 1);
    end
    histgramTarget(:, 1) = histgramTarget(:, 1)/total;
    
    %% ֱ��ͼƥ��
    J = histeq(im, histgramTarget);
    %% ��ֵ�˲�
    G = fspecial('average', 10);
    J = imfilter(J, G,'same');
    
end