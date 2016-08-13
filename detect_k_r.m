function [ k r ] = detect_k_r( A )
%DETECT_K_R Summary of this function goes here
%   Detailed explanation goes here
    k = 0; r=0;
    
    for i = 1:size(A,1)
        val=find(A(i,:), 1, 'last') - i;
        if(~isempty(val))
            k = max(val,k);
        end
    end
    for i = 1:size(A,1)
        val = find(A(:,i), 1, 'last') - i;
        if(~isempty(val))
            r = max(val,r);
        end
    end

end

