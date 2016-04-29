function v2_perp = get_v2_perp(X, predictors, observations, y, lambda_known, lambda2, lambda_max, est_known)
assert(lambda_known>0)
assert(lambda_known<lambda_max)

est_dual = (y - X*est_known)/lambda_known;

% p = y - X*est2;
% alpha = min(max((y'*p)/lambda2/norm(p,2)^2,-1.0/norm(X'*p,inf)),1.0/norm(X'*p,inf));
% est = alpha * p;

% v1 = get_v1(X, y, lambda_known, lambda_max, est_dual);
v1 = y/lambda_known - est_dual;
v2 = y/lambda2 - est_dual;
v2_perp = v2 - (v1' * v2) /norm(v1,2)^2 * v1;
