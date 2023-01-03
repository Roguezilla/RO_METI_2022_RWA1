clc;
clear;
% all edges 
u = [1 1 1 1 2 2 2 3 3 3 4 4 4  5 5 5  6 6 6 7 7  8 8  9  9  10];
v = [2 3 4 7 3 5 8 4 5 6 7 8 10 6 8 11 7 8 9 9 10 9 11 10 11 11];
w = [953 622 361 641 356 321 343 576 171 318 281 877 525 190 266 697 594 294 251 529 251 490 641 594 261 625];
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