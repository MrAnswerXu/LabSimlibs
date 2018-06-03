function X=Repeat(x,config)
nums=config.nums;

    if config.repeat==1
        X=repmat(x,1,nums);
    elseif config.repeat==2
        X=repmat([x(1)*ones(1,length(x)),x],[1,nums]);
    end
end