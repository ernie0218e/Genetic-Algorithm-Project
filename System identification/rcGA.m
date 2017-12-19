% genetic algorithm
% Input:
% Output:
function [params, generation, fit_hist] = rcGA(n, ell)

    % initialize population
    % parents
    chromosomes = initPopulation(n, ell);
    % children
    offspring = initPopulation(n, ell);
    
    generation = 0;
    final_fitness = zeros(n, 1);
    fit_hist = [];
    while (true)
        % evaluate fitness
        fitness = evalFitness(chromosomes);
        
        % check termination
        if (shouldTerminate(fitness, generation))
            final_fitness = fitness;
            break;
        else
            generation = generation + 1;
        end
        
        % selection (use tournament selection w/o replacement here)
        selectionIndex = tournamentSelection(fitness);
        
        % crossover
        crossover(chromosomes, selectionIndex, offspring);
        
        % mutation
        %mutaionClock(offspring);
        
        % replace Population
        replacePopulation(offspring, chromosomes)
        
        [maxFitness, maxInd] = max(fitness);
        fit_hist(generation) = -maxFitness;
%         disp(-maxFitness)
%         fprintf(1, 'fitness: %f, params: %f %f %f %f %f\n', -maxFitness, chromosomes(maxInd).getGene());
        fprintf(1, 'fitness: %f, params: %f %f\n', -maxFitness, chromosomes(maxInd).getGene());
    end
    
    [maxFitness, maxInd] = max(final_fitness);
    disp(-maxFitness)
    disp(generation)
    params = chromosomes(maxInd).getGene();
    fit_hist = fit_hist';
end

% Purpose: initialize the population
% Input: n - size of the population (# of chromosomes)
%        ell - current # of generation
% Output: chromosomes - (n x 1) generated pupulation
function chromosomes = initPopulation(n, ell)
    chromosomes = Chromosome.empty(n, 0);
    for i = 1:n
        chromosomes(i) = Chromosome(ell);
        r = GAConst.minParam + (GAConst.maxParam-GAConst.minParam).*rand(ell, 1);
        chromosomes(i).setGene(r);
    end
    chromosomes = chromosomes';
end

% Purpose: evaluate all fitness parallelly
% Input: chromosomes - (n x 1) the population
% Output: fitness - (n x 1) fitness of all chromosomes
function fitness = evalFitness(chromosomes)
    % initialize variables
    n = size(chromosomes, 1);
    
    fitness = zeros(n, 1);
    for i = 1:n
        fitness(i) = chromosomes(i).getFitness();
    end
    
    % get current parallel pool
%     p = gcp();
%     for i = 1:n
%         future(i) = parfeval(p, @getFitness, 1, chromosomes(i));
%     end
%     
%     % Collect the results as they become available.
%     fitness = zeros(n, 1);
%     for i = 1:n
%         % fetchNext blocks until next results are available.
%         [completedIdx,value] = fetchNext(future);
%         fitness(completedIdx, 1) = value;
%     end
    
end

% Purpose: check whether the GA should terminate based on the fitness and
%           # of generation
% Input: fitness - (n x 1) fitness of all chromosomes
%        generation - current # of generation
% Output: termination - boolean
function termination = shouldTerminate(fitness, generation)
    
    termination = false;
    
    % Reach maximal # of generations
    if (generation > GAConst.maxGen)
        termination = true;
    end

    % Found a satisfactory solution
    if (max(fitness) >= GAConst.maxFitness)
        termination = true;
    end

    % The population loses diversity
    if (max(fitness) < mean(fitness))
        termination = true;
    end
    
end

% Purpose: Do the tournament selection without replacement
%          (Assume the population size won't change with time.)
function selectionIndex = tournamentSelection(fitness)
    nCurrent = size(fitness, 1);
    selectionIndex = zeros(nCurrent, 1);
    
    % generate random index in range [1, nCurrent]
    randArray = zeros(GAConst.selectionPressure * nCurrent, 1);
    for s = 1:GAConst.selectionPressure
        randArray((1+(s-1)*nCurrent):(s*nCurrent), 1) = randi(nCurrent, nCurrent, 1);
    end
    
    for i = 1:nCurrent
        challenger = randArray((1+(i-1)*GAConst.selectionPressure):(i*GAConst.selectionPressure), 1);
        challengerFitness = fitness(challenger, 1);
        [~, maxInd] = max(challengerFitness);
        selectionIndex(i, 1) = challenger(maxInd);
    end
    
end

function crossover(chromosomes, selectionIndex, offspring)
    nCurrent = size(chromosomes, 1);
    if (mod(nCurrent, 2) == 0)
        for i=1:2:nCurrent
            BLX_alpha(chromosomes(selectionIndex(i)), chromosomes(selectionIndex(i+1)), ...
                offspring(i), offspring(i+1));
        end
    else
        for i=1:2:(nCurrent-1)
            BLX_alpha(chromosomes(selectionIndex(i)), chromosomes(selectionIndex(i+1)), ...
                offspring(i), offspring(i+1));
        end
        copy(chromosomes(nCurrent), offspring(nCurrent));
    end
end

function BLX_alpha(chr1, chr2, off1, off2)
    alpha = 0.5;
    if (rand() < GAConst.pc)
        gene1 = chr1.getGene();
        gene2 = chr2.getGene();
        
        cmax = max([gene1, gene2], [], 2);
        cmin = min([gene1, gene2], [], 2);
        
        I = cmax - cmin;
        
        a = cmin - alpha.*I;
        b = cmax + alpha.*I;
        
        off1.setGene(a + (b-a).*rand(size(gene1, 1),1));
        off2.setGene(a + (b-a).*rand(size(gene1, 1),1));
    else
        % copy the content from chr1 to off1
        copy(chr1, off1);
        copy(chr2, off2);
    end
end

function mutaionClock(offspring)
    n = size(offspring, 1);
    ell = size(offspring(1).getGene(), 1);
    % can't deal with too small pm
    if (GAConst.pm <= 1e-6)
        return
    end
    pointer = (log(1-rand())) / (log(1-GAConst.pm) + 1);
    while (pointer < n*ell)
        q = floor(pointer / ell);
        r = mod(pointer, ell);
        
        % do the mutation
        
        pointer = pointer + (log(1-rand())) / (log(1-GAConst.pm) + 1);
    end
end

function replacePopulation(offspring, chromosomes)
    n = size(chromosomes, 1);
    for i = 1:n
        copy(offspring(i), chromosomes(i));
    end
end