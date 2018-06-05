% 用于生成训练数据
close all 
clear all
warning('off')
% delete DataContainer_0603.mat
%% 参数配置
Tx =[0,0];
Rx1=[1,0];
Rx2=[0,1];
n=500;
% 运动轨迹参数
channel_num=4;% 不同的channel 对应不同的动作 
Mconfig.n=n; %仿真点数
Mconfig.flag_flip=0; % 若为1，则对动作进行拷贝，单次模拟实现一次往返运动
% 场景及信号参数
config.repeat=3;
config.nums=1;
% 频偏参数
Fconfig.flag=1; % 1为添加频偏和相位噪声
Fconfig.mode=1; % mode=1 仿真的频偏和相位噪声  mode=2 实测数据的频偏信息
Fconfig.theta=0.05; % 仿真相位噪声的标准差
% get data
monte_num=1e4;
get_ind=n+1:2*n;
containerRx1=zeros(channel_num,monte_num,n);
containerRx2=zeros(channel_num,monte_num,n);

AbsmotionRx1=zeros(channel_num,monte_num,n);
AbsmotionRx2=zeros(channel_num,monte_num,n);

Rs_compRx1=zeros(channel_num,monte_num,n);
Rs_compRx2=zeros(channel_num,monte_num,n);
%%仿真开始
for k=1:4
   channel=k;
for i=1:monte_num
%% step one 
% 生成实际的运动轨迹图
% 参考 GenDATA2pythonV1.m
[x,y]=GenMotionTrace(channel,Mconfig);
%% step two 
% 根据运动轨迹图生成数据Rsignal
% 信号重复，方便生成数据
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
Rsignal1=GenFreoffset(Rsignal1_c,Fconfig);
Rsignal2=GenFreoffset(Rsignal2_c,Fconfig);
%% step three
% 处理生成好的数据 得到相位信息
% 参考jucibocheck.m
[Path_d1,abs_motion1,Rs_comp1]=GenPhase(Rsignal1,Fconfig);
[Path_d2,abs_motion2,Rs_comp2]=GenPhase(Rsignal2,Fconfig);
%% step four  记录数据
pd=phase(Path_d1);
spd=smooth(pd,101);
pd2=phase(Path_d2);
spd2=smooth(pd2,101);

containerRx1(k,i,:)=spd(get_ind);
containerRx2(k,i,:)=spd2(get_ind);


AbsmotionRx1(k,i,:)=abs_motion1(get_ind);
AbsmotionRx2(k,i,:)=abs_motion2(get_ind);

Rs_compRx1(k,i,:)=Rs_comp1(get_ind);
Rs_compRx2(k,i,:)=Rs_comp2(get_ind);
end
flag_save=1;
    if flag_save==1
        if exist('DataContainer_0603.mat')==0
           save('DataContainer_0604_V2','containerRx1','containerRx2','AbsmotionRx1','AbsmotionRx2','Rs_compRx1','Rs_compRx2');
        else
           save('DataContainer_0604_V2','containerRx1','containerRx2','AbsmotionRx1','AbsmotionRx2','Rs_compRx1','Rs_compRx2','-append');
        end
    end 
end
%% 可视化

% plot(containerRx1(4,:,:).',containerRx2(4,:,:).');

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
