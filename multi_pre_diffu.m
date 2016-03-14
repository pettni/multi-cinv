%% multi_pre: backwards reachable set for a family of systems
function [C_pre] = multi_pre(C, A, B, XUset, epsilon)

	%  For (A_i, B_i), find a set C_pre s.t.
	%  for all x \in C_pre, there exists a u s.t. (x,u) \in XUset
	%  s.t. A_i x + B_i u \in C - epsilon.

	if nargin < 5
		epsilon = 0;
	end

	n = C.Dim;	 		% system dimension
	N = length(A); % number of systems

	C_pre = Polyhedron('H', zeros(0,n+1));
    for i = 1:N
		numold = size(C_pre.H,1);
		newpoly = multi_pre(C, {A{i}}, {B{i}}, XUset, epsilon);
		C_pre = Polyhedron('H', [C_pre.H; newpoly.H]); % intersect
		myMinHRep(C_pre, numold+1);
    end
