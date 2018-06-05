function X=Repeat(x,config)
nums=config.nums;
    if config.repeat==2
        X=repmat([x(1)*ones(1,length(x)),x],[1,nums]);
    elseif config.repeat==3
        X=repmat([x(1)*ones(1,length(x)),x,x(end)*ones(1,length(x))],[1,nums]);
    else
        X=repmat(x,1,nums);
    end
end