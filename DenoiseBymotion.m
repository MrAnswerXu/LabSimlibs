function p_motion=DenoiseBymotion(spd,abs_motion)

p_motion=zeros(1,length(spd));
for i=2:length(spd)
    if abs_motion(i)==1
        p_motion(i)=p_motion(i-1)+spd(i)-spd(i-1);
    else
        p_motion(i)=p_motion(i-1);
    end
end

end