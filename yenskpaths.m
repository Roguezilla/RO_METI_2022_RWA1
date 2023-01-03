function [paths, dists, hops]=yenskpaths(G2, s, t, k)
    % copy the graph so we don't ruin it for the other runs
    G = G2;
    
    % initialize all the arrays or else matlab will complain
    paths = {};
    dists = {};
    hops = {};

    while k > 0 
        [path, dist, edges]=shortestpath(G,s,t);
        % if the "new" path we found is in the array already, then we
        % reached the "limit" and can stop searching
        if isarraymember(paths, path) == 1
            break;
        end

        paths{end+1}=path;
        dists{end+1}=dist;
        hops{end+1}=length(path)-1;
        
        % set the weight of the path edges to a very big number so the
        % algorithm is forced to find a new different path next time
        G.Edges.Weight(edges)=100000000;

        k = k - 1;
    end
end

% a function to check if array is in array of arrays
function out=isarraymember(array, item)
    out = 0;
    for i = 1:length(array)
        if length(item) == length(array{i})
            if item == array{i}
                out = 1;
            end
        end
    end
end