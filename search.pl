%% Depth first search.
%% Arguments: arc function (+), start node (+), goal predicate (+), solution (-)
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

%% Breadth first search.
%% Arguments: arc function (+), start node (+), goal predicate (+), solution (-)
breadth_first_search(Arc, Start, GoalPred, Sol) :-
	bfs(Arc, [[Start]], [], GoalPred, Sol).

%% The second argument is the open queue.
%% The third argument is the closed list.
bfs(_, [[Node|Path]|_], _, GoalPred, [Node|Path]) :-
	call(GoalPred, Node).
bfs(Arc, [[Node|Path]|MoreOPEN], CLOSED, GoalPred, Sol) :-
	% Find the new neighbords of the first OPEN node,
	% and add the current path to each of them.
	findall([Next, Node|Path],
		(call(Arc, Node, Next),
		 not(member([Next|_], [[Node|Path]|MoreOPEN])),
		 not(member(Next, CLOSED))),
		NewPaths),
	% Place the new paths on the end of the queue.
	append(MoreOPEN, NewPaths, NewOPEN),
	bfs(Arc, NewOPEN, [Node|CLOSED], GoalPred, Sol).q