
tic

lambda_max = abs(A(:,1)'*y);
for feature = 2:predictors
    if lambda_max < abs(A(:,feature)'*y)
        lambda_max = abs(A(:,feature)'*y);
    end
end

dpp_feature_keep_length = zeros(0);
edpp_feature_keep_length = zeros(0);
tru_pred_length = zeros(0);

% lambda = 1.0/10^6;
lambda = 1.0/10^8;

lambdas = zeros(0);

fail_grid1 = zeros(10,10);
fail_grid2 = zeros(10,10);
for lambda_counter = 1:10
    lambda = lambda/10;
%     lambda = 1.0/5^(2+lambda_counter-1+10);
    lambdas = [lambdas; lambda];

    cvx_begin quiet
        cvx_precision best
        variable est(predictors,1);
        minimize( 1.0/2.0*pow_pos(norm(A*est - y, 2),2) ...
            + lambda * norm(est,1))
    cvx_end
    
    if isnan(est)
        isnan(est)
        return
    end

    tru_pred = zeros(0);
    tru_not_pred = zeros(0);
    for i = 1:length(est)
        if abs(est(i)) > 0.000001
            tru_pred = [tru_pred; i];
        else
            tru_not_pred = [tru_not_pred; i];
        end
    end
    tru_pred_length = [tru_pred_length length(tru_pred)];

%     tru_pred;
%     est(tru_pred);
    
    lambda_prime_factors = zeros(0);

    for counter = 1:10

        lambda_prime_factor = 1.0001 + 0.01*(counter-1);
        
%         lambda_prime_factor = 1+ 1/10^(counter+3);
        
%         lambda_prime_factor = 1.+1./10.^(10+4-counter+1);
        
        lambda_prime_factors = [lambda_prime_factors; lambda_prime_factor];
        lambda_prime = lambda*lambda_prime_factor;
        
        if lambda_prime >= lambda_max
            'lambda_prime >= lambda_max'
        end
        
        cvx_begin quiet
            cvx_precision best
            variable est_prime(predictors,1);
            minimize( 1.0/2.0*pow_pos(norm(A*est_prime - y, 2),2) ...
                + lambda_prime * norm(est_prime,1))
        cvx_end
        
        norm(A*est_prime-y,2)
        
        if isnan(est_prime)
            isnan(est_prime)
            return
        end
        
        v2_perp = get_v2_perp(A, predictors, observations, y, lambda_prime, ...
                                lambda, lambda_max, est_prime);

        feature_keep = zeros(0);
        for feature = 1:predictors
            if abs( A(:,feature)'*(((y-A*est_prime)/lambda) ...
                    +1/2*v2_perp)) >= 1 - 1/2.0*norm(A(:,feature),2) * norm(v2_perp,2)
                feature_keep = [feature_keep; feature];
            end
        end
        edpp_feature_keep_length = [edpp_feature_keep_length length(feature_keep)];

        if checkScreen(feature_keep, tru_pred)
            
        else
            'Fail edpp'
            
            if length(feature_keep) > 0
                fail_grid1(lambda_counter,counter)=...
                    getScreenFailCount((feature_keep), tru_pred)...
                    /length(tru_pred);
            else
                fail_grid1(lambda_counter,counter)=1;                
            end
%             lambda;
%             edpp_feature_keep_length;
%             tru_pred_length;
        end

        feature_keep = zeros(0);
        for feature = 1:predictors            
            if abs(A(:,feature)'*(y-A*est_prime))/lambda_prime >= 1 ...
                    - norm(A(:,feature),2) * norm(y,2) ...
                    * (lambda_prime-lambda)/(lambda*lambda_prime)
                feature_keep = [feature_keep; feature];
            end
        end
        dpp_feature_keep_length = [dpp_feature_keep_length length(feature_keep)];

        if checkScreen(feature_keep, tru_pred)
        else
            'Fail dpp'
            
            if length(feature_keep) > 0
                fail_grid2(lambda_counter,counter)=...
                    getScreenFailCount((feature_keep), tru_pred)...
                    /length(tru_pred);
            else
                fail_grid2(lambda_counter,counter)=1;                
            end
            
%             fail_grid2(lambda_counter,counter)=1;

%             feature_keep;
        end
    end
end

fail_grid1
fail_grid2

imagesc(fail_grid1);
c = colorbar;
c.Label.String = 'Percent of relevant predictors discarded';

title('EDPP Failure Region')
ylabel('\lambda')
xlabel('\lambda'' /\lambda')
% xlabel('log(\lambda'' /\lambda-1)')
set(gca,'YTickLabel',lambdas)
set(gca,'XTickLabel',lambda_prime_factors)
% set(gca,'XTickLabel',round(log(lambda_prime_factors-1)))

toc
