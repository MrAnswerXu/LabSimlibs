function var=varfunc(x)
  N=length(x);
  u=sum(x)/N;
  var=sum((x-u).^2)/(N-1);
end