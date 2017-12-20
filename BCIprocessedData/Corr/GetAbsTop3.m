function [top3indices,top3value,NaNch] = GetAbsTop3(a)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    numCh=length(a);
    NaNi=isnan(a);
    a(NaNi)=0;
    indices=1:numCh;
    sortTable=[a;indices];
    sorted=sortrows(abs(sortTable'),-1);

    top3indices=sorted(1:3,2);
    top3value=a(top3indices);
    top3indices=top3indices';
    NaNch=indices(NaNi);

end

