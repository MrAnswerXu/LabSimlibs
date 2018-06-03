%{
% �� ��: GenSignal.m
% �� ��: ����Ŀ���˶��켣�����ź� 
% �� ��: x,y���꣬�շ���λ�õȲ���
% �� �� ֵ: ʱ���ŵ���Ӧ�ķ�������
% ʱ��: 20180530 
%}
function Rsignal=GenSignal(X,Y,config)
%% ���������һ���շ������ź�
%% ��config����ȡ����
Tx=config.Tx;
Rx=config.Rx;
d=pdist2(Tx,Rx);
repeat=config.repeat;
%% �̶�����
RCSd=0.01;
RCS=10*log10(RCSd); %ɢ��ϵ��
e=5;%��糣��
f=2300e6; % �ز�Ƶ��
c=3e8; %����
lambda=c/f;%����
Ptransmit=10; %ֱ��·������(�������)
rLosdB=-10*log10(d);%ֱ��·���źŷ���(���ջ���) ����������Ϊ20����������Ϊ10��
SNRdB=37;
SNR=power(10,SNRdB/20);
randnum=randi(100);
randn('seed',randnum);
tau=1;
mode=1;

n=length(X);
%% ��ʼ������
noise=Ptransmit*power(10,rLosdB/10)/SNR*(randn(1,n)+1i*randn(1,n))/sqrt(2);
Rsignal=zeros(1,n);
RNlos=zeros(1,n);

%% ���濪ʼ
    for i = 1:length(X)
        % ���㷴���
        x=X(i);
        y=Y(i);
        % ������ն�ֱ��·���ͷ���·���źŷ���֮�ȣ�����֮�ȳ���2��
        dt=sqrt( (Tx(1)-x)^2+(Tx(2)-y)^2 );
        dr=sqrt( (Rx(1)-x)^2+(Rx(2)-y)^2 );
        ratio=PowerRatio(RCS,tau,dt,dr,d,mode);
        rNlosdB=rLosdB-ratio/2;
        % ����ֱ��·���ͷ���·����λ��
        Phasediff=(dt+dr-d)/lambda*2*pi;
        % ������ջ��ź�
        RNlos(i)=Ptransmit*(power(10,rNlosdB/10)*exp(1i*Phasediff));

        Rsignal(i)=Ptransmit*power(10,rLosdB/10)+RNlos(i);
    end
    Rsignal=Rsignal+noise;
end