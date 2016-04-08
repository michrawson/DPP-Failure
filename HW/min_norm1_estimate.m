function est = min_norm1_estimate(F, data, n)

cvx_begin  
    variable est(n,1) complex;
    minimize( norm(est, 1) )
    subject to
        F*est == data;
cvx_end
