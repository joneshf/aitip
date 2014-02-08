%% One simple graph.
incid(a,[b,c]).
incid(b,[d,e]).
incid(c,[b,f,g]).
incid(d,[h,i]).
incid(e,[d,j]).
incid(f,[b,j]).
incid(g,[k,l]).
incid(h,[]).
incid(i,[a]).
incid(j,[]).
incid(k,[f]).
incid(l,[k]).

arc(X, Y) :- incid(X, L), member(Y, L).

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
	bfs(Arc, NewOPEN, [Node|CLOSED], GoalPred, Sol).

%% More efficient BFS.
breadth_first_search2(Arc, Start, GoalPred, Sol) :-
	bfs2(Arc, [[Start]|Qtail], Qtail, [], GoalPred, Sol).

%% If the queue is empty, fail.
bfs2(_, OPEN, Qtail, _, _, _) :- OPEN == Qtail, !, fail.
bfs2(_, [[Node|Path]|_], _, _, GoalPred, [Node|Path]) :-
	call(GoalPred, Node).
bfs2(Arc, [[Node|Path]|MoreOPEN], Qtail, CLOSED, GoalPred, Sol) :-
	findall([Next, Node|Path],
		(call(Arc, Node, Next),
		 not(dlmember([Next|_], [[Node|Path]|MoreOPEN], Qtail)),
		 not(member(Next, CLOSED))),
		NewPaths),
	% We actually use the difference list.
	append(NewPaths, NewQtail, Qtail),
	bfs2(Arc, NewPaths, NewQtail, [Node|CLOSED], GoalPred, Sol).