%{
% �� ��: GenPhase.m
% �� ��: ����ʱ���ŵ���Ӧ��ȡ������·�� 
% �� ��: ʱ���ŵ���Ӧ
% �� �� ֵ: ��ȡ���ķ���·��
% ʱ��: 20180530 
%}
function [Path_d,abs_motion,Rs_comp]=GenPhase(RsignalNoise,Fconfig)
%% ����Ϊ���������ŵ���Ӧ�� ͨ������������ȡ����·��
%% ��ȡ����
n=length(RsignalNoise);
flag_freoffset=Fconfig.flag;
%% �̶�����
absThreshold=0.0005;
%% ��������Ƶƫ����λ����
if flag_freoffset==1
    pa = phase(RsignalNoise);    
    spa = smooth(pa,101).';
    RsignalNoise = RsignalNoise.*exp(-1i*spa);
end
    Rs_comp=RsignalNoise;
%% ������ȷ����ϵ�� �����ж�
absa=abs(RsignalNoise);
n_sf=n;
len=100;
abs_motion=zeros(1,n);
for i=len:n_sf
    vars(i-len/2)=var(absa(i-len+1:i)/max(absa(i-len+1:i)));
    abs_motion(i-len/2)=vars(i-len/2)>=absThreshold;
end
% vars_real=vars(len/2:n_sf-len/2);


%% ��ȡ����·�� ��ƽ������ƽ��
Path_d=smooth(RsignalNoise,21)-smooth(RsignalNoise,101);
% pd = phase(d);   % ����Ŀ���ǰ�d������������
% Singal_p = smooth(phase(d),101); 

end