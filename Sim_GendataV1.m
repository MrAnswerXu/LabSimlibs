%{
说明： 本文的主要目的是数据生成，通过仿真数据并按照实际流程处理信号得到类似实测数据的信号，用于后续处理。
时间： 20180530
%}
close all 
clear all
%% 参数配置
for kk=1:4
Tx =[0,0];
Rx1=[1,0];
Rx2=[0,1];
n=500;
shape=1;
%% step one 
% 生成实际的运动轨迹图
% 参考 GenDATA2pythonV1.m
channel=4;% 不同的channel 对应不同的动作
Mconfig.n=n; %仿真点数
[x,y]=GenMotionTrace(channel,Mconfig);


% center=[randi([50,350]),randi([50,350])]/10;
% % radius=location/2;
% radius=randi([30,200])/10;
% [x,y]=GenCircle(center,radius,n);

%% step two 
% 根据运动轨迹图生成数据Rsignal
% 参考jucibocheck.m

% 信号重复，方便生成数据
config.repeat=1;
config.nums=1;
X=Repeat(x,config);
Y=Repeat(y,config);

%生成信号1
config.Tx=Tx;
config.Rx=Rx1;
Rsignal1_c=GenSignal(X,Y,config);
%生成信号2
config.Rx=Rx2;
Rsignal2_c=GenSignal(X,Y,config);
%% 附加频偏
Fconfig.flag=1; % 1为添加频偏和相位噪声
Fconfig.mode=1; % mode=1 仿真的频偏和相位噪声  mode=2 实测数据的频偏信息
Fconfig.theta=0.05; % 仿真相位噪声的标准差
Rsignal1=GenFreoffset(Rsignal1_c,Fconfig);

Rsignal2=GenFreoffset(Rsignal2_c,Fconfig);
%% step three
% 处理生成好的数据 得到相位信息
% 参考jucibocheck.m
[Path_d1,abs_motion1,Rs_comp1]=GenPhase(Rsignal1,Fconfig);

[Path_d2,abs_motion2,Rs_comp2]=GenPhase(Rsignal2,Fconfig);
%% step four 
% 生成共后续训练的数据

%% 可视化
flag_fig=0;
if flag_fig==1
figure(6);
plot(x,y);
    
    
ind=find(abs_motion1==1);
ind2=find(abs_motion2==1);
figure(1);
subplot(211)
data1=smooth(abs(Rsignal1_c),21);
plot(data1);
hold on
plot(ind,data1(ind),'.');
title('Rx1原始数据幅度')
subplot(212)
data2=smooth(abs(Rsignal2_c),21);
plot(data2);
hold on
plot(ind2,data2(ind2),'.');

title('Rx2原始数据幅度')
figure(2);
plot(phase(Rsignal1_c));
hold on 
plot(phase(Rsignal2_c));
title('原始数据相位')

% figure(3);
% plot(abs(Path_d1));
% hold on
% plot(ind,abs(Path_d1(ind)),'.');
% title('反射数据幅度')

figure(4);
pd=phase(Path_d1);
spd=smooth(pd,101);
pd2=phase(Path_d2);
spd2=smooth(pd2,101);

plot(pd,'linewidth',2);
hold on 
h1=plot(spd,'linewidth',2);
plot(ind,spd(ind),'.');

plot(pd2,'linewidth',2);
h2=plot(spd2,'linewidth',2);
plot(ind2,spd2(ind2),'.');
title('仿真反射数据相位')
legend([h1,h2],'Rx1','Rx2')
xlabel('t')
ylabel('Phase')
grid on 
set(gca,'Fontsize',16);

figure(7)

subplot(211)
title('频偏补偿后的相位')
plot(smooth(phase(Rs_comp1),21));
hold on
grid on
subplot(212)
plot(smooth(phase(Rs_comp2),21));
grid on

p_motion1=DenoiseBymotion(spd,abs_motion1);

p_motion2=DenoiseBymotion(spd2,abs_motion2);

figure(9);
subplot(211)
plot(pd);
hold on 
h1=plot(spd);
plot(ind,spd(ind),'.');

plot(pd2);
h2=plot(spd2);
plot(ind2,spd2(ind2),'.');
title('反射数据相位')
legend([h1,h2],'Rx1','Rx2')
grid on 
subplot(212)
plot(p_motion1);
hold on 
plot(p_motion2);
grid on

figure(5)
subplot(1,3,1)
plot(x,y);
axis equal
subplot(1,3,2)
plot(spd,spd2);
axis equal
grid on
subplot(1,3,3)
% hold on
plot(p_motion1,p_motion2);
axis equal
grid on
end

flag=2;
if flag==1
pd=phase(Path_d1);
spd=smooth(pd,101);
pd2=phase(Path_d2);
spd2=smooth(pd2,101);
figure(5)
plot(spd(50:n),spd2(50:n),'linewidth',2);
hold on 
elseif flag==2
    pd=phase(Path_d1);
    spd=smooth(pd,101);
    pd2=phase(Path_d2);
    spd2=smooth(pd2,101);
    figure(5)
    plot(spd,spd2,'linewidth',2);
    hold on 
end

    figure(1)
    plot(x,y,'linewidth',2);
    hold on 
end
figure(5)
title('仿真反射数据相位')
xlabel('Phase\_Rx1')
ylabel('Phase\_Rx2')
axis equal
set(gca,'Fontsize',16);
grid on
axis equal