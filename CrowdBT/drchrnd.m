function r = drchrnd(a,n)

p = length(a);
r = gamrnd(repmat(a,n,1),1,n,p); % Replicate a   n in row, and m=1 in column
r = r ./ repmat(sum(r,2),1,p);

end