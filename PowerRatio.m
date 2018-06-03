function ratio=PowerRatio(RCS,tau,dt,dr,d,mode)

if mode==1
%     ratio=-RCS-20*log10(tau)+20*log10((dt*dr)/d)+10*log10(4*pi); % 包含反射系数
      ratio=-RCS+20*log10((dt*dr)/d)+10*log10(4*pi);    % 不包含反射系数
else
    ratio=20*log10((dt+dr)/(d*tau));
end

end