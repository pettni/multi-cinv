%% multi_pre: backwards reachable set for a family of systems
function [C_pre] = multi_pre(C, A, B, E, K, XUset, Dset, epsilon)

	%  For (A_i, B_i, E_i), find a set C_pre s.t.
	%  for all x \in C_pre, there exists a u s.t. (x,u) \in XUset
	%  s.t. A_i x + B_i u + E_i d \in C - epsilon for all d \in Dset

	if nargin < 7
		epsilon = 0;
	end

	if length(B) == 0
		B = repmat({zeros(C.Dim,0)}, 1, length(A));
		XUset = Polyhedron('H', zeros(0,C.Dim))
	end

	if length(E) == 0
		E = repmat({zeros(C.Dim,0)}, 1, length(A));
		Dset = Polyhedron('H', zeros(0,1));
	end

	if length(K) == 0
		K = repmat({zeros(C.Dim,1)}, 1, length(A));
	end

	n = C.Dim;	 		% system dimension
	N = length(A); % number of systems

	C_pre = Polyhedron('H', zeros(0,n+1));
    for i = 1:N
		numold = size(C_pre.H,1);
		newpoly = multi_pre(C, {A{i}}, {B{i}}, {E{i}}, {K{i}}, XUset, Dset, epsilon);
		C_pre = Polyhedron('H', [C_pre.H; newpoly.H]); % intersect
		myMinHRep(C_pre);
    end
