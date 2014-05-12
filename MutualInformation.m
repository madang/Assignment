function oMI = MutualInformation(a,b)
%MUTUALINFORMATION Find mutual information similarity measure for images a
%and b. Units are bits.
%   function oMI = MutualInformation( a,b)

%% NOTES
% The hardest part here is to build a mutual distribution.
% I've invented a stupid hack using complex numbers how to do this quickly
%


% if ~isa(a,'uint8') || ~isa(b,'uint8')
%     a = double(uint8(a)); % I need to have doubles so that max works on complex numbers
%     b = double(uint8(b)); % But I need those boubles to have only 256 different values
% end
%% Mutual histogram
% This is a hack to speed things up a little bit
c=sort(a(:)*256+b(:)); % make a matrix where each unique combination of a and b values yields a unique value
counter=histc(c,0:65535);
counter(counter==0)=[];
counter=counter./numel(a);
HAB=-sum(counter.*log2(counter)); % using bit as a unit of entropy
    
counter=histc(a,0:255);
counter(counter==0)=[];
counter=counter./numel(a);
HA=-sum(counter.*log2(counter));

counter=histc(b,0:255);
counter(counter==0)=[];
counter=counter./numel(b);
HB=-sum(counter.*log2(counter));

oMI=HA+HB-HAB;
