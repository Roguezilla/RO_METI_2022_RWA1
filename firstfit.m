function firstFit = firstfit(pc, lambdasForLink, maxLambda, path)
    % stores the lambdas on the path
    lambdasOnPath = [];
    % stores the links on the given path
    linksOnPath = pathtolinks(path);
    % add all lambdas on path to path_lambdas
    for i=1:length(linksOnPath)
        % bidirectional first fit means that 1 2 == 2 1 in lambda terms
        % so we need to flip 2 1 to get 1 2 which is in lambdas_for_link
        if ismirror(pc, linksOnPath{i})
            key = num2str(fliplr(linksOnPath{i}));
        else
            key = num2str(linksOnPath{i});
        end
        temp = lambdasForLink(key);
        for j=1:length(temp)
            lambdasOnPath(end+1) = temp(j);
        end
    end
    
    % remove all dupes from path_lambdas and find the first fitting lambda
    % for the path
    firstFit = findfirstfit(maxLambda, unique(lambdasOnPath));
    
    % add the first fitting lambda to all the links on the path
    for i=1:length(linksOnPath)
        if ismirror(pc, linksOnPath{i})
            key = num2str(fliplr(linksOnPath{i}));
        else
            key = num2str(linksOnPath{i});
        end
        temp = lambdasForLink(key);
        temp(end+1) = firstFit;
        lambdasForLink(key) = temp;
    end
end

% finds the first missing lambda in the array
% if given for example [1 4 3] will output 2
function firstFit = findfirstfit(maxLambda, lambdasOnPath)
    for lambda=1:maxLambda
        % if lambda not in in lambdasOnPath, then return this lambda
        if ~any(ismember(lambdasOnPath, lambda))
            firstFit = lambda;
            return
        end
    end
end

% a link is a mirror if it's not in the automatically generated pathTable
function out = ismirror(pathTable, link)
    out = 1;
    for i=1:length(pathTable)
        for j=1:length(pathTable{i})
            if i == link(1) && pathTable{i}(j) == link(2)
                out = 0;
            end
        end
    end
end

% breaks a path into its links
function out = pathtolinks(path)
    out = {};
    for i=1:length(path)-1
        out{end+1} = [path(i) path(i+1)];
    end
end