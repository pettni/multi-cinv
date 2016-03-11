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

	% add epsilon-ball disturbance
	Dset = Polyhedron('A', [eye(n); -eye(n)], 'b', epsilon*ones(2*n,1));
	E = eye(n);

	H_rep = repmat({C.A}, 1, N);
	H_diag = blkdiag(H_rep{:});

	Hx = H_diag * [cell2mat(A') cell2mat(B')];
	hx = repmat(C.b, N, 1) - max(H_diag*repmat(E, N,1)*Dset.V', [], 2);
	pre_proj = intersect(Polyhedron(Hx, hx), XUset);

	myMinHRep(pre_proj);

	C_pre = projection(pre_proj, 1:n, 'ifourier');

	myMinHRep(C_pre);