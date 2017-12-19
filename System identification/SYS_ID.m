% start system identification
clear;
n = 65;
ell = 5;

ave_g = 0;
fit_all = {};
min_gen = Inf;
for i = 1:10
    [params, generation, fit_hist] = rcGA(n, ell);
    ave_g = ave_g + generation;
    if min_gen > generation
        min_gen = generation;
    end
    fit_all{i} = fit_hist;
end
ave_g = ave_g/10;

fit = zeros(min_gen, 1);
for i = 1:10
    fit = fit + fit_all{i}(1:min_gen, :);
end
fit = fit / 10;