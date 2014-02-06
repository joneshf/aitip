%% Depth first search.
%% Arguments: arch function (+), start node (+), goal predicate (+), solution (-)
depth_first_search(Arc, Start, GoalPred, Sol) :-
	dfs(Arc, [[Start]], [], GoalPred, Sol).

%% The second argument is the open stack.
%% The third argument is the closed list.
dfs(_, [[Node|Path]|_], _, GoalPred, [Node|Path]) :-
	call(GoalPred, Node).
dfs(Arc, [[Node|Path]|MoreOPEN], CLOSED, GoalPred, Sol) :-
	% Find the new neighbors of the first OPEN node,
	% and add the current path to each of them.
	findall([Next, Node|Path],
		(call(Arc, Node, Next),
		 not(member([Next|_], [[Node|Path]|MoreOPEN])),
		 not(member(Next, CLOSED))),
		NewPaths),
	% Place the new paths on the top of the stack.
	append(NewPaths, MoreOPEN, NewOPEN),
	dfs(Arc, NewOPEN, [Node|CLOSED], GoalPred, Sol).