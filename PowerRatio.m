function ratio=PowerRatio(RCS,tau,dt,dr,d,mode)

if mode==1
%     ratio=-RCS-20*log10(tau)+20*log10((dt*dr)/d)+10*log10(4*pi); % ��������ϵ��
      ratio=-RCS+20*log10((dt*dr)/d)+10*log10(4*pi);    % ����������ϵ��
else
    ratio=20*log10((dt+dr)/(d*tau));
end

end