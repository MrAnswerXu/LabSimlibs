%{
% 名 称: GenPhase.m
% 功 能: 根据时域信道响应提取出反射路径 
% 参 数: 时域信道响应
% 返 回 值: 提取出的反射路径
% 时间: 20180530 
%}
function [Path_d,abs_motion,Rs_comp]=GenPhase(RsignalNoise,Fconfig)
%% 输入为有噪声的信道响应， 通过后续步骤提取反射路径
%% 提取参数
n=length(RsignalNoise);
flag_freoffset=Fconfig.flag;
%% 固定参数
absThreshold=0.0005;
%% 补偿残留频偏和相位噪声
if flag_freoffset==1
    pa = phase(RsignalNoise);    
    spa = smooth(pa,101).';
    RsignalNoise = RsignalNoise.*exp(-1i*spa);
end
    Rs_comp=RsignalNoise;
%% 计算幅度方差波动系数 动静判断
absa=abs(RsignalNoise);
n_sf=n;
len=100;
abs_motion=zeros(1,n);
for i=len:n_sf
    vars(i-len/2)=var(absa(i-len+1:i)/max(absa(i-len+1:i)));
    abs_motion(i-len/2)=vars(i-len/2)>=absThreshold;
end
% vars_real=vars(len/2:n_sf-len/2);


%% 提取反射路径 短平滑减长平滑
Path_d=smooth(RsignalNoise,21)-smooth(RsignalNoise,101);
% pd = phase(d);   % 最终目的是把d这个数组求出来
% Singal_p = smooth(phase(d),101); 

end