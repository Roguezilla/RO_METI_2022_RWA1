function sortedPaths = sortedyensk(G, pathTable, k)
    global debug;
    
    % initialize all the arrays or else matlab will complain
    % stores the sorted paths
    sortedPaths = {};
    % stores the distances because we need them for sorting
    distanceForPath = {};

    if debug
        disp("Getting shortest paths with Yen's k-Shortest Path...")
    end
    for i=1:length(pathTable)
        for j=1:length(pathTable{i})
            if debug
                disp("Shortest path from " + i + " to " + pathTable{i}(j));
            end
            [path, dist] = yenskshortestpath(G, i, pathTable{i}(j), k);
            if debug
                disp("Path (distance): " + num2str(path) + " (" + num2str(dist) + ")")
            end
            sortedPaths{end+1} = path;
            distanceForPath{end+1} = dist;
            fprintf("\n")
        end
    end
    
    if debug 
        disp("Sorting by distance...")
        fprintf("\n")
    end
    % bubble sort, extremely inefficient bue does its job
    for i=1:length(sortedPaths)
        for j=1:length(sortedPaths)-i
            if distanceForPath{j} > distanceForPath{j+1}
                temp = distanceForPath{j};
                distanceForPath{j} = distanceForPath{j+1};
                distanceForPath{j+1} = temp;
    
                temp2 = sortedPaths{j};
                sortedPaths{j} = sortedPaths{j+1};
                sortedPaths{j+1} = temp2;
            end
        end
    end
end