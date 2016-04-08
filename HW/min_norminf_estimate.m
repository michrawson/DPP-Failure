function est = min_norminf_estimate(F, data, n)

cvx_begin  
    variable est(n,1) complex;
    minimize( norm(est, Inf) )
    subject to
        F*est == data;
cvx_end
