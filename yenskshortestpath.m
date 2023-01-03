function [path, dist]=yenskshortestpath(G, s, t, k)
    % distance is also returned because we need to sort the paths later on
    
    % precedence for choosing the shortest path:
    % 1. distance
    % 2. hops
    [paths, distances, hops] = yenskpaths(G, s, t, k);
    
    % finds the paths with the smallest distance and returns them alongside
    % their distances and hops
    function [outPaths, outDists, outHops]=judgebydistance()
        % find smallest distance
        smallest = 9999999;
        for i = 1:length(distances)
            if distances{i} < smallest
                smallest = distances{i};
            end
        end
           
        % initialize all the arrays or else matlab will complain
        outPaths = {};
        outDists = {};
        outHops = {};
        % find the paths with the distance found above
        for i = 1:length(distances)
            if distances{i} == smallest
                outPaths{end+1} = paths{i};
                outDists{end+1} = distances{i};
                outHops{end+1} = hops{i};
            end
        end
    end
    
    % finds the paths with the least hops and returns them
    function [outPath, outDist]=judgebyhops(judgedPaths, judgedDists, judgedHops)
        % find smallest hop number
        smallest = 9999999;
        for i = 1:length(judgedHops)
            if judgedHops{i} < smallest
                smallest = judgedHops{i};
            end
        end
        
        % initialize all the arrays or else matlab will complain
        pathsTemp = {};
        distsTemp = {};
        % find the paths with the hop number found above
        for i = 1:length(judgedHops)
            if judgedHops{i} == smallest
                pathsTemp{end+1} = judgedPaths{i};
                distsTemp{end+1} = judgedDists{i};
            end
        end
        
        % because we are not taking grid load into account, just return the
        % first path and its distance
        outPath = pathsTemp{1};
        outDist = distsTemp{1};
    end
    
    % distance takes precendence, if there's only 1 path found then that
    % path is the one we are looking for
    [judgedPaths, judgedDists, judgedHops] = judgebydistance();
    if length(judgedPaths) == 1
        path = judgedPaths{1};
        dist = judgedDists{1};
    else
        % there are many paths with the same distance, so we have to decide
        % using hops
        [path, dist] = judgebyhops(judgedPaths, judgedDists, judgedHops);
    end
end