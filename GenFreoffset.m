%{
% �� ��: GenFreoffset.m
% �� ��: ������λ������Ƶƫ 
% �� ��: ��������ʱ���ŵ���Ӧ+���ò���
% �� �� ֵ: ��������ʱ���ŵ���Ӧ
% ʱ��: 20180530 
%}

function Rsignal=GenFreoffset(Rsignal,config)
%% ������ȡ
Pmode=config.mode;
theta=config.theta;
n=length(Rsignal);
if config.flag==1
    load freOffset.mat
    % pa=paBS;
    % PmodeΪ1�Ƕ���ʽ���Ƶƫ��modeΪ2Ϊֱ�ӵ�����ʵ��Ƶƫ
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
        % ��0��ʼ
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