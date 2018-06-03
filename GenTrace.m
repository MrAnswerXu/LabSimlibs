%{
% 名 称: GenTrace.m
% 功 能: 生成目标运动轨迹 
% 参 数: x,y轴的关键点坐标，仿真点数，运动形状
% 返 回 值: 运动轨迹坐标
% 时间: 20180530 
%}
function [x,y]=GenTrace(config_Curve)
    n=config_Curve.n;
    if strcmpi(config_Curve.shape,'line')
        xlim=config_Curve.xlim;
        ylim=config_Curve.ylim;
        x=linspace(xlim(1),xlim(2),n);
        y=linspace(ylim(1),ylim(2),n);
    elseif strcmpi(config_Curve.shape,'circle')
        centerx=config_Curve.center(1);
        centery=config_Curve.center(2);
        radius=config_Curve.radius;
        alpha=linspace(0,2*pi,n);
        x=centerx+radius*cos(alpha);
        y=centery+radius*sin(alpha);
    elseif strcmpi(config_Curve.shape,'gou')
        start=config_Curve.start;
        %随机右下的长度
        mid=config_Curve.mid;
        %随机右上的长度
        ends=config_Curve.ends;
        % 绘制出勾曲线
        x1=linspace(start(1),mid(1),n/2);
        y1=linspace(start(2),mid(2),n/2);
        %下
        x2=linspace(mid(1),ends(1),n/2);
        y2=linspace(mid(2),ends(2),n/2);
        %上
        x=[x1,x2];
        y=[y1,y2];
    end
end