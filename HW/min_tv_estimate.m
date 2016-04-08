function est = min_tv_estimate(F, data, n)

cvx_begin  
    variable est(n,1) complex;
    minimize( norm(est(1:n-1)-est(2:n),1) )
    subject to
        F*est == data;
cvx_end
