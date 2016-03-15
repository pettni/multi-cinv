% Question: how does discretization impact algo?

clear; yalmip('clear');
global sdpopt

sdpopt = sdpsettings('verbose', 0);
mptopt('lpsolver', 'gurobi');

% define constants
con = constants;

syms v p1 p2;
f = [1/v, v];
p = [p1, p2];

% Define system s.t. pi = f(i)
c22 = -((con.Caf+con.Car)/con.m);
c24 = (con.b*con.Car - con.a*con.Caf)/con.m;
c42 = ((con.b*con.Car-con.a*con.Caf)/con.Iz);
c44 = -((con.a^2*con.Caf+con.b^2*con.Car)/con.Iz);

A = [0 1      p2 0  ;
     0 c22*p1 0  c24*p1-p2 ;
     0 0      0  1  ;
     0 c42*p1 0  c44*p1];
B = [0; con.Caf/con.m; 0; con.a*(con.Caf/con.Iz)];
E = [0; 0; -1; 0];

% scale the system to unit box
scale = 0;

% perform various tests along the way
sanity_check = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Compute systems in convex hull %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

func_poly = compute_hull(f, [con.u_min con.u_max], sanity_check);

% Build polytopes
A_vertices = {};
B_vertices = {};
E_vertices = {};
for vert = func_poly.V'
    A_vertices{end+1} = double(subs(A, p, vert'));
    B_vertices{end+1} = double(subs(B, p, vert'));
    E_vertices{end+1} = double(subs(E, p, vert'));
end

disp(['found ', num2str(length(A_vertices)), ' vertex systems'])

if sanity_check
    % are matrices along curve contained in convex hull?
    AV_cell = cellfun(@vec, A_vertices, 'UniformOutput', false);
    A_poly = Polyhedron('V', [AV_cell{:}]');
    BV_cell = cellfun(@vec, B_vertices, 'UniformOutput', false);
    B_poly = Polyhedron('V', [BV_cell{:}]');
    EV_cell = cellfun(@vec, E_vertices, 'UniformOutput', false);
    E_poly = Polyhedron('V', [EV_cell{:}]');
    for val = con.u_min:(con.u_max-con.u_min)/10:con.u_max
        assert(A_poly.contains(vec(double(subs(subs(A, p, f), v, val)))));
        assert(B_poly.contains(vec(double(subs(subs(B, p, f), v, val)))));
        assert(E_poly.contains(vec(double(subs(subs(E, p, f), v, val)))));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Stabilize and discretize  %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% K = joint_stab(A_vertices, B, sanity_check);
K = zeros(1,4);

A_vertices_stable = cellfun(@(A) A-B*K, A_vertices, 'UniformOutput', 0);

A_vertices_discrete = cellfun(@(A) eye(4) + con.dt*A, A_vertices_stable, 'UniformOutput', 0);
B_vertices_discrete = cellfun(@(B) con.dt*B,          B_vertices, 'UniformOutput', 0);
E_vertices_discrete = cellfun(@(B) con.dt*E,          E_vertices, 'UniformOutput', 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Compute invariant set %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C0 = Polyhedron('A', [eye(4); -eye(4)], ...
			   'b', [con.y_max; con.nu_max; con.psi_max; con.r_max; con.y_max; con.nu_max; con.psi_max; con.r_max]);
XUset = Polyhedron('H', [-K 1 con.df_max; K -1 con.df_max]);
Dset = Polyhedron('H', [1 con.rd_max; -1 con.rd_max])

% Scale the problem to unit box
if scale
  T = diag([1/con.y_max 1/con.nu_max 1/con.psi_max 1/con.r_max]);
  C0 = T*C0;
  A_vertices_discrete = cellfun(@(A) T*A*inv(T), A_vertices_discrete, 'UniformOutput', 0);
  B_vertices_discrete = cellfun(@(B) T*B, B_vertices_discrete, 'UniformOutput', 0);
  E_vertices_discrete = cellfun(@(A) T*E, E_vertices_discrete, 'UniformOutput', 0);
  XU_A = XUset.A;
  XUset = Polyhedron('A', [XU_A(:,1:4)*inv(T) XU_A(:,5)], 'b', XUset.b);
end

C = C0;
iter = 0;

while not (C <= multi_pre_diffu(C, A_vertices_discrete, B_vertices_discrete, E_vertices_discrete, [], XUset, Dset, 0.0))
  Cpre = multi_pre_diffu(C, A_vertices_discrete, B_vertices_discrete, E_vertices_discrete, [], XUset, Dset, 0.005);

  if Cpre.isEmptySet
    break
  end

  C = Polyhedron('H', [Cpre.H; C0.H]); % intersect

  myMinHRep(C);
  
  iter = iter+1;
  disp(sprintf('\n'))
  disp(['iteration ', num2str(iter), ', ', num2str(size(C.A,1)), ' inequalities'])
end

if scale
  C = inv(T)*C;
end

save('simulation/safeset_lk.mat', 'C', 'con', 'func_poly', 'K', 'A_vertices_discrete')