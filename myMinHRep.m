function [obj] = myMinHRep(obj, startidx)

	if nargin<2
		startidx = 1;
	end

	% Need hrep
	assert(obj.hasHRep)

	% Does not support equality constraints
	assert(length(obj.Ae) == 0)
	assert(length(obj.be) == 0)

	if obj.irredundantHRep
		return
	end

	disp(['doing myMinHRep on polyhedron with ', num2str(size(obj.A,1)), ' inequalities starting at ', num2str(startidx)])
	tic

	i=startidx;
	while ( i<=size(obj.H_int,1) )
				
		A = obj.H_int(:, 1:end-1);
		b = obj.H_int(:, end);
				
		H = obj.H_int;
		cost = H(i,1:end-1);
		offset = H(i,end);
		H(i,end) = H(i,end) + 1;
		
		% Setup data for fast call to LP solver
		lpn.f = -cost(:);
		
		lpn.A = H(:,1:end-1);
		lpn.b = H(:,end);
		
		% try to solve without lb/ub first
		res = mpt_solve(lpn);

		if (-res.obj < offset + 1e-6)
			% inequality was redundant
			obj.H_int(i,:) = [];
		else
			i = i+1;
		end
	end

	obj.irredundantHRep = true;
	obj.optMat = [];

	time = toc;
	disp(['finished myMinHRep after ', num2str(time), ' at ', num2str(size(obj.A,1)), ' inequalities'])

end

