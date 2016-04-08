close all
clear all
rng('default');
rng(2016);

% Signal
n = 128;
n_disc = 10;
aux_perm = randperm(n);
loc = sort(aux_perm(1:n_disc));
signal = randn * ones(n,1);
for i= 1:(n_disc-1)
	signal(loc(i):loc(i+1)) = randn;
end
figure
p=plot(signal,'--.')
title('Signal')
saveas(p,'Signal.png')

%%% Denoising %%%

% Measurement matrix
F = dftmtx(n)/sqrt(n);
std_noise = 0.3;
noise = std_noise * randn(n,1);
data = F * signal + noise;


figure
p=plot(real(inv(F)*data),'--.')
title('Reconstruction ignoring noise')
saveas(p,'ignoring_noise.png')

% Total-variation regularization
lambda_tv_small = .00001
lambda_tv_medium = 1.
lambda_tv_large = 100000.
denoised_signal_tv_1 = tv_denoising(F, data, n, lambda_tv_small);
denoised_signal_tv_2 = tv_denoising(F, data, n, lambda_tv_medium);
denoised_signal_tv_3 = tv_denoising(F, data, n, lambda_tv_large);

figure
p=plot(real(denoised_signal_tv_1),'--.')
title('Denoising via total-variation regularization, small lambda')
saveas(p,'small_lambda.png')

figure
p=plot(real(denoised_signal_tv_2),'--.')
title('Denoising via total-variation regularization, medium lambda')
saveas(p,'medium_lambda.png')

figure
p=plot(real(denoised_signal_tv_3),'--.')
title('Denoising via total-variation regularization, large lambda')
saveas(p,'large_lambda.png')

%%% Compressed sensing %%%

% Regular undersampling
F_reg = F(1:2:end,:);
data_reg = F_reg * signal;

% Minimum l2-norm solution
est_reg_l2 = min_norm_estimate(F_reg, data_reg, n)

% Minimum TV-norm solution
est_reg_tv = min_tv_estimate(F_reg, data_reg, n)

figure
p=plot(real(est_reg_l2),'--.')
title('Regular undersampling, minimum-l2-norm solution')
saveas(p,'reg_under_l2.png')

figure
p=plot(real(est_reg_tv),'--.')
title('Regular undersampling, minimum-total-variation solution')
saveas(p,'reg_under_tv.png')

% Random undersampling
aux_rand = randperm(n)
F_rand = F(aux_rand(1:n/2),:);
data_rand = F_rand * signal;

% Minimum l2-norm solution
est_rand_l2 = min_norm_estimate(F_rand, data_rand, n)

% Minimum TV-norm solution
est_rand_tv = min_tv_estimate(F_rand, data_rand, n)

figure
p=plot(real(est_rand_l2),'--.')
title('Random undersampling, minimum-l2-norm solution')
saveas(p,'rand_under_l2.png')

figure
p=plot(real(est_rand_tv),'--.')
title('Random undersampling, minimum-total-variation solution')
saveas(p,'rand_under_tv.png')
