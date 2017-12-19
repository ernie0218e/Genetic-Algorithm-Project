classdef GAConst
   properties (Constant)
       % maximal # of generations
       maxGen = 500;
       % maximum value of fitness
       maxFitness = -1e-5;
       % selection pressure
       selectionPressure = 2;
       % Pc
       pc = 0.8;
       % Pm
       pm = 1e-3;
       % maximum value of the parameter
       maxParam = 20;
       % minimum value of the parameter
       minParam = -20;
   end
end