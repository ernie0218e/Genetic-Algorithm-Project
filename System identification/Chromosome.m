classdef Chromosome < handle
    properties
        length;
        gene;
        evaluated;
        fitness;
    end
    methods
        
        function obj = Chromosome(ell_length)
            obj.length = ell_length;
            obj.gene = zeros(obj.length, 1);
            obj.evaluated = false;
            obj.fitness = 0;
        end
        
        function copy(obj, obj2)
            obj2.gene = obj.gene;
            obj2.evaluated = obj.evaluated;
            obj2.fitness = obj.fitness;
        end
        
        function gene = getGene(obj)
            gene = obj.gene;
        end
        
        function setGene(obj, gene)
            obj.gene = gene;
            obj.evaluated = false;
        end
        
        function val = getVal(obj, index)
            if (index < 1 || index > obj.length)
                disp('Error: Out of range')
                val = -1;
            else
               val = obj.gene(index, 1);
            end
        end
        
        function setVal(obj, index, val)
            if (index < 1 || index > obj.length)
                disp('Error: Out of range')
            else
               obj.gene(index, 1) = val;
               obj.evaluated = false;
            end
        end
        
        function e = isEvaluated(obj)
            e = obj.evaluated;
        end
        
        function f = getFitness(obj)
            if (~obj.isEvaluated())
                obj.evaluated = true;
                obj.fitness = calculateFitness(obj.gene);
            end
            f = obj.fitness;
        end
        
    end
end