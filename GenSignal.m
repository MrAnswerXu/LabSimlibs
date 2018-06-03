%{
% 名 称: GenSignal.m
% 功 能: 根据目标运动轨迹生成信号 
% 参 数: x,y坐标，收发机位置等参数
% 返 回 值: 时域信道响应的仿真数据
% 时间: 20180530 
%}
function Rsignal=GenSignal(X,Y,config)
%% 生成相对于一对收发机的信号
%% 从config中提取参数
Tx=config.Tx;
Rx=config.Rx;
d=pdist2(Tx,Rx);
repeat=config.repeat;
%% 固定参数
RCSd=0.01;
RCS=10*log10(RCSd); %散射系数
e=5;%介电常数
f=2300e6; % 载波频率
c=3e8; %光速
lambda=c/f;%波长
Ptransmit=10; %直射路径幅度(发射机处)
rLosdB=-10*log10(d);%直射路径信号幅度(接收机处) （功率因子为20，幅度因子为10）
SNRdB=37;
SNR=power(10,SNRdB/20);
randnum=randi(100);
randn('seed',randnum);
tau=1;
mode=1;

n=length(X);
%% 初始化数据
noise=Ptransmit*power(10,rLosdB/10)/SNR*(randn(1,n)+1i*randn(1,n))/sqrt(2);
Rsignal=zeros(1,n);
RNlos=zeros(1,n);

%% 仿真开始
    for i = 1:length(X)
        % 计算反射角
        x=X(i);
        y=Y(i);
        % 计算接收端直射路径和反射路径信号幅度之比（功率之比除以2）
        dt=sqrt( (Tx(1)-x)^2+(Tx(2)-y)^2 );
        dr=sqrt( (Rx(1)-x)^2+(Rx(2)-y)^2 );
        ratio=PowerRatio(RCS,tau,dt,dr,d,mode);
        rNlosdB=rLosdB-ratio/2;
        % 计算直射路径和反射路径相位差
        Phasediff=(dt+dr-d)/lambda*2*pi;
        % 计算接收机信号
        RNlos(i)=Ptransmit*(power(10,rNlosdB/10)*exp(1i*Phasediff));

        Rsignal(i)=Ptransmit*power(10,rLosdB/10)+RNlos(i);
    end
    Rsignal=Rsignal+noise;
end