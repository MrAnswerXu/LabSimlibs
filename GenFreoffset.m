%{
% 名 称: GenFreoffset.m
% 功 能: 附加相位噪声和频偏 
% 参 数: 无噪声的时域信道响应+配置参数
% 返 回 值: 有噪声的时域信道响应
% 时间: 20180530 
%}

function Rsignal=GenFreoffset(Rsignal,config)
%% 参数提取
Pmode=config.mode;
theta=config.theta;
n=length(Rsignal);
if config.flag==1
    load freOffset.mat
    % pa=paBS;
    % Pmode为1是多项式拟合频偏，mode为2为直接叠加真实的频偏
    if Pmode ==1
%         disp([length(pa),n]);
        start=randi([1,max(length(pa)-n,1)]);
        y=pa(start:start+min([length(pa),n])-1).';
        poly=randi([2,10],1);
        
        p = polyfit(1:length(y),y,poly);
        x=1:n;
        freOffset = polyval(p,x);
        freOffset_s=freOffset/max(abs(freOffset))*randi(300);
        Pnoise=theta*randn(1,n);
        freOffset=freOffset_s+Pnoise;
        % 从0开始
        freOffset=freOffset-freOffset(1);
    else
        start=randi([1,length(pa)-n]);
        freOffset=pa(start:start+n-1).';
        freOffset=freOffset-freOffset(1);
    end



    phaseWithFreOffset=phase(Rsignal)+freOffset;
    Rsignal=abs(Rsignal).*exp(1i*phaseWithFreOffset);

end
end