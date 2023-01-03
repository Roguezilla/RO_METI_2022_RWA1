clc;
clear;
% all edges
u = [1 1 2 2 3 3 4 5];
v = [2 6 3 6 5 4 5 6];
w = [5 8 5 3 3 5 8 5];
G = graph(u, v, w);
p = plot(G, 'EdgeLabel', G.Edges.Weight);

% generate all possible connections a node can have
% without dupes like 2 1 because 1 2 is already generated
nodeCount = length(unique([u v]));
pathTable = {};
for i=1:nodeCount-1
    pathTable{i} = [];
    for j=i+1:nodeCount
        pathTable{i}(end+1) = j;
    end
end

% max lambda number, use intmax for infinite
maxLambda = 8;
% link -> lambda values
lambdasForLink = containers.Map('KeyType','char','ValueType','any');
% set all possible links to no lambdas aka empty array
for i=1:length(pathTable)
    for j=1:length(pathTable{i})
        lambdasForLink(num2str([i pathTable{i}(j)])) = [];
    end
end
% stores the lambda and shortest path for a "valid" path(variable paths)
% key: num2str([start_point end_point])
% value: [fmi path...]
lambdaForPath = containers.Map('KeyType','char','ValueType','any');

global debug;
debug = 1;

% how many paths to find (the end array can and probably will be smaller
% because at some point the algorithm will find paths already found
% previously)
k = 10;
% basically yenskshortestpath for all paths sorted by distance
paths = sortedyensk(G, pathTable, k);

disp("Running first fit on sorted paths...")
for i=1:length(paths)
    disp("Path: " + num2str(paths{i}))
    firstFit = firstfit(pathTable, lambdasForLink, maxLambda, paths{i});
    disp("Assigned Lambda: " + firstFit)
    fprintf("\n")
    
    % bidirectional so mirror paths share the same lambda
    key = [paths{i}(1) paths{i}(end)];
    lambdaForPath(num2str(key)) = [firstFit paths{i}];
    lambdaForPath(num2str(fliplr(key))) = [firstFit fliplr(paths{i})];
end