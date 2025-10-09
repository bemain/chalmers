% this file shows first the NONPARAMETRIC BOOTSTRAP applied to aspirin data,
% then it shows the PARAMETRIC BOOTSTRAP
%________________________________________________________________________

% data consists of having observed two groups of subjects: 
% - first group consists of  11,037 subjects taking aspirin. Among these, 119 experience a stroke
% - the second group consists of 11,034 subjects taking a placebo. Among these, 98 experience a stroke

n_stroke_A = 119;  % number of subjects experiencing a stroke in aspirin group (A)
n_stroke_P = 98;  % number of subjects experiencing a stroke in placebo group  (P)
n_A = 11037;      % number of subjects in group A
n_P = 11034;      % number of subjects in group P

% observed odds ratio of a stroke
obs_odds_stroke = (n_stroke_A/n_A) / (n_stroke_P/n_P);  % equals 1.214. 
% That is being in group A suggests a 21% increase of chance of getting a
% stroke.
% However, as usual, it is not enough to have an estimate. We always need
% an evaluation of the estimate uncertainty.

z_quantile = norminv(0.025,0,1); % (z_{alpha/2} is -1.96 for alpha=0.05)
% The odds ratio 95% confidence interval is 
[exp(log(obs_odds_stroke) + z_quantile*(sqrt(1/119+1/10918+1/98+1/10936))), exp(log(obs_odds_stroke) -z_quantile*(sqrt(1/119+1/10918+1/98+1/10936)))]
% so what do we really conclude? See the slides at lecture.

% What if we did not have the nice formula above?

%:::::::::: an example of nonparametric bootstrap ::::::::::::::::::::::
% set the random seet, to obtain replicable results
rng(123)

% suppose we do not know the data-generating model. We just resample from
% available data
data_A = [ones(1,n_stroke_A),zeros(1,n_A-n_stroke_A)];  % concantenate n_stroke_A ones and n_A-n_stroke_A zeroes
data_P = [ones(1,n_stroke_P),zeros(1,n_P-n_stroke_P)];  % concantenate n_stroke_A ones and n_A-n_stroke_A zeroes

% obtain a single (nonparametric) bootstrap sample with replacement
replace = 1;  % replace = 0 for sampling without replacement
sample_A = randsample(data_A,n_A,replace);
sample_P = randsample(data_P,n_P,replace);

% we can now obtain a single simulated (nonparametric bootstrap) odds of a
% stroke, which is
(sum(sample_A)/n_A) / (sum(sample_P)/n_P)  % gives an odds of stroke of 1.8023
% ok now that we learned the procedure let's do it many many times. Say
% 1000 times

B = 1000;  % the number of bootstrap simulations
boots_odds = zeros(B,1);  % initialize a vector of zeroes where we store our results

for ii=1:B
    % simulate bootstrapped data
    sample_A = randsample(data_A,n_A,replace);
    sample_P = randsample(data_P,n_P,replace);
    boots_odds(ii) = (sum(sample_A)/n_A) / (sum(sample_P)/n_P);
end

hist(boots_odds)
xlabel('odds ratio','FontSize',14)  % give a name to the x-axis label and change the font size
title('nonparametric bootstrap','FontSize',14)  % give a title to the plot and change the font size

% use the percentile method to obtain 95% confidence bounds
lower_bound = prctile(boots_odds,2.5)
upper_bound = prctile(boots_odds,97.5)
% or you could do prctile(boots_odds,[2.5,97.5]);

%:::::::::: an example of parametric bootstrap ::::::::::::::::::::::
% set the random seet, to obtain replicable results
rng(123)

% simulate a dataset from group A, having size n_A.
% we can do this by simulating from a Bernoulli distribution.
% maximum likelihoood estimate of probability of a stroke in group A is p_A = n_stroke_A/n_A
p_A = n_stroke_A/n_A;
% we use the function that simulates from a Binomial distribution
% this is because a Benoulli is a special case of the Binomial(a,p) when a=1.
% To simulate n_A Bernoulli draws using binornd use binornd(1,p_A,[1,n_A])
sample_A = binornd(1,p_A,[1,n_A]);  % many zeroes and a few ones

% simulate a dataset from group P, having size n_P.
% maximum likelihoood estimate of probability of a stroke in group P is p_P = n_stroke_P/n_P
p_P = n_stroke_P/n_P;
sample_P = binornd(1,p_P,[1,n_P]); % many zeroes and a few ones

% we can now obtain a single simulated (parametric bootstrap) odds ratio of a
% stroke, which is
(sum(sample_A)/n_A) / (sum(sample_P)/n_P)  % gives an odds ratio of stroke of 1.8023

% ok now that we learned the procedure let's do it many many times. Say
% 1000 times

B = 1000;  % the number of bootstrap simulations
boots_odds = zeros(B,1);  % initialize a vector of zeroes where we store our results

for ii=1:B
    % simulate bootstrapped data
    sample_A = binornd(1,p_A,[1,n_A]);
    sample_P = binornd(1,p_P,[1,n_P]);
    boots_odds(ii) = (sum(sample_A)/n_A) / (sum(sample_P)/n_P);
end

hist(boots_odds)
xlabel('odds ratio','FontSize',14)  % give a name to the x-axis label and change the font size
title('parametric bootstrap','FontSize',14)  % give a title to the plot and change the font size

% use the percentile method to obtain 95% confidence bounds
lower_bound = prctile(boots_odds,2.5)
upper_bound = prctile(boots_odds,97.5)
% or you could do prctile(boots_odds,[2.5,97.5]);

