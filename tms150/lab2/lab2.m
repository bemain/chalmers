%%
% load data
cd("~/Chalmers/tms150/lab2/")
load('diabetes.txt');
data = diabetes;

histogram(data, 80);
title('Actual glucose concentration measurements')
xlabel('Glucose concentration (mg/dL)');
ylabel('Density');




%% Task i (a)
K = 3;
% By looking at the histogram I guess some starting values for the means
% (80, 130, 190), and input them in increasing order.
startpar = struct("mu", [85; 130; 190], "Sigma", ones(1,1,3));
GM = fitgmdist(data, K, 'Start', startpar); % Fit a Gaussian mixture model

% Our estimated parameters of the Gaussian mixture model.
mu = GM.mu; % The vector of fitted means (mu_1,...,mu_K)
sigma = sqrt(GM.Sigma); % The fitted standard deviations (s_1,...,s_K)
pi = GM.ComponentProportion; % The fitted mixing proportions pi_1,...,pi_K




%% Task i (b)
pi(2) % 0.2980




%% Task ii
rng(123) % For reproducibility

% Sample n values from a Gaussian mixture model.
function [data] = sample_mixture(pi, mu, sigma, n)
    arguments
        pi(:,1) double {mustBeFinite};
        mu(:,1) double {mustBeFinite};
        sigma(:,1) double {mustBeFinite};
        n int32 {mustBeFinite} = 500;

    end
    cum_weights = cumsum(pi); % cumulative sum of all probabilities
    rs = rand(n, 1); % uniform draws in (0,1)
    k_star = arrayfun(@(r) find(r <= cum_weights, 1), rs); % a single randomly sampled component
    data = normrnd(mu(k_star),sigma(k_star));
end

n = size(data,1); % The number of data points in the diabetes dataset
x_star = sample_mixture(pi, mu, sigma, n); % Simulate new data

% Plot
histogram(x_star, 80)
title('Simulated glucose concentration measurements')
xlabel('Glucose concentration (mg/dL)');
ylabel('Density');




%% Task iii
rng(123) % For reproducibility


B = 2000; % Fix the number of bootstrap re-samples
mus = zeros(B, K); % The means for each iteration. Will be filled
sigmas = zeros(B, K); % The standard deviations for each iteration. Will be filled
pis = zeros(B, K); % The mixing proportions for each iteration. Will be filled

% Sample n values from the empirical distribution for x, with replacement.
function [data] = sample_empirical(x, n)
    arguments
        x(:,1) double {mustBeFinite};
        n int32 {mustBeFinite} = 500;
    end
    data = randsample(x, n, true);
end

% 3. Repeat
for b = 1:B
    x_star = sample_empirical(data, n); % 1. Sample a new data set
    % 2. Estimate parameters
    GM = fitgmdist(x_star, K, 'Start', startpar); % Fit a Gaussian mixture model
    mus(b,:) = GM.mu; % Store the fitted means
    sigmas(b,:) = sqrt(GM.Sigma(1,1,:)); % Store the fitted standard deviations
    pis(b,:) = GM.ComponentProportion; % Store the mixing proportions
end

% Plot data obtained from a non-parametric bootstrap, with appropriate labels
function [] = plot_nonparam(data, xlab, BinWidth)
    figure();
    hold on
    for k = 1:size(data,2)
        histogram(data(:,k), BinWidth=BinWidth);
    end
    title('Non-parametric Bootstrap Estimates of ' + xlab + 's');
    xlabel(xlab);
    ylabel('Density');
    legend('Healthy','Prediabetics','Diabetics')
end

% Generate histograms
plot_nonparam(mus, "Mean", 0.5);
plot_nonparam(pis, "Mixing Proportion", 0.005);
plot_nonparam(sigmas, "Standard Deviation", 0.1);
legend('Healthy','Prediabetics','Diabetics')

% Create confidence intervals
prctile(mus, [2.5, 97.5], 1) % CIs for mu
prctile(sigmas, [2.5, 97.5], 1) % CIs for sigma
prctile(pis, [2.5, 97.5], 1) % CIs for pi




%% Task iv
rng(123) % For reproducibility

B = 2000; % Fix the number of bootstrap samples
mus = zeros(B, K); % The means for each iteration. Will be filled
sigmas = zeros(B, K); % The standard deviations for each iteration. Will be filled
pis = zeros(B, K); % The mixing proportions for each iteration. Will be filled

% 3. Repeat
for b = 1:B
    x_star = sample_mixture(pi, mu, sigma, n); % 1. Sample a new data set
    % 2. Estimate parameters
    GM = fitgmdist(x_star, K, 'Start', startpar); % Fit a Gaussian mixture model
    mus(b,:) = GM.mu; % Store the fitted means
    sigmas(b,:) = sqrt(GM.Sigma(1,1,:)); % Store the fitted standard deviations
    pis(b,:) = GM.ComponentProportion; % Store the mixing proportions
end

% Plot data obtained from a nonparametric bootstrap, with appropriate labels
function [] = plot_param(data, xlab, BinWidth)
    figure();
    hold on
    for k = 1:size(data,2)
        histogram(data(:,k), BinWidth=BinWidth);
    end
    title('Parametric Bootstrap Estimates of ' + xlab + 's');
    xlabel(xlab);
    ylabel('Density');
    legend('Healthy','Prediabetics','Diabetics')
end

% Generate histograms
plot_param(mus, "Mean", 0.5);
plot_param(pis, "Mixing Proportion", 0.005);
plot_param(sigmas, "Standard Deviation", 0.1);




%% Task v

sum(mus(:, 1) >= 85) / B % Probability that mean >= 85 for healthy subjects = 0.0885
sum(mus(:, 2) >= 85) / B % Probability that mean >= 85 for prediabetic subjects = 1.0