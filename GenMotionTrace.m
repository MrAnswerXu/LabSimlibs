function [x,y]=GenMotionTrace(channel,config)
n=config.n;
if channel==1
    % 垂直直线运动
    xlim=randi([0,100],1)*ones(1,2)/100;
    ylim=randi([0,30],1)*ones(1,2)/100+[0,randi([60,70],1)/100];
    disp(['Vline',xlim,ylim]);
    config_Curve.xlim=xlim;
    config_Curve.ylim=ylim;
    config_Curve.shape='line';
    config_Curve.n=n;
    [x,y]=GenTrace(config_Curve);
    x=[x, fliplr(x)];
    y=[y, fliplr(y)];
elseif channel==2
    % 水平直线运动
    ylim=randi([0,100],1)*ones(1,2)/100;
    xlim=randi([0,30],1)*ones(1,2)/100+[0,randi([60,70],1)/100];
    disp(['Hline',xlim,ylim]);
    config_Curve.xlim=xlim;
    config_Curve.ylim=ylim;
    config_Curve.shape='line';
    config_Curve.n=n;
    [x,y]=GenTrace(config_Curve);
    x=[x, fliplr(x)];
    y=[y, fliplr(y)];   
elseif channel==3
    % 圆
    config_Curve.center=randi([20,80],1,2)/100;
    maxV=min(40,floor(min(config_Curve.center)*100));
    disp(maxV)
    config_Curve.radius=randi([20,maxV])/100;
    disp(['circle',config_Curve.center,config_Curve.radius])
    config_Curve.shape='circle';
    config_Curve.n=n;
    [x,y]=GenTrace(config_Curve);
    
elseif channel==4
    % 勾
    
    %随机起始点
    config_Curve.start=[randi([0,30]),randi([40,100])]/100;
    %随机右下的长度
    config_Curve.mid=config_Curve.start+[randi([20,40]),-config_Curve.start(2)*100]/100;
    %随机右上的长度
    config_Curve.ends=config_Curve.mid+[randi([30,50]),randi([40,100])]/100;
    
    % disp([config_Curve.center,config_Curve.radius])
    config_Curve.shape='gou';
    config_Curve.n=n;
    [x,y]=GenTrace(config_Curve);
    % x=[x, fliplr(x)];
    % y=[y, fliplr(y)];
elseif channel==0
    xi=randi([0,100],1)/100;
    yi=randi([0,100],1)/100;
    x=xi*ones(1,n);
    y=yi*ones(1,n);
end
end