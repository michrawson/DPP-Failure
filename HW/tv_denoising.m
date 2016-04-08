function est = tv_denoising(F, data, n, lambda)

cvx_begin  
    variable est(n,1);
    minimize( pow_pos(norm(F*est - data, 2),2) ...
        + lambda * norm(est(1:n-1)-est(2:n),1))
cvx_end
