% Question: how does discretization impact algo?

clear; yalmip('clear');
global sdpopt

sdpopt = sdpsettings('verbose', 0);
mptopt('lpsolver', 'gurobi');

% define constants
con = constants;
dt = 0.1;

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

% interval for v
v_ival = [25 30];

% perform various tests along the way
sanity_check = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Compute systems in convex hull %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

func_poly = compute_hull(f, v_ival, sanity_check);

% Build polytopes
A_vertices = {};
B_vertices = {};
for vert = func_poly.V'
    A_vertices{end+1} = double(subs(A, p, vert'));
    B_vertices{end+1} = double(subs(B, p, vert'));
end

disp(['found ', num2str(length(A_vertices)), ' vertex systems'])

if sanity_check
    % are matrices along curve contained in convex hull?
    AV_cell = cellfun(@vec, A_vertices, 'UniformOutput', false);
    A_poly = Polyhedron('V', [AV_cell{:}]');
    BV_cell = cellfun(@vec, B_vertices, 'UniformOutput', false);
    B_poly = Polyhedron('V', [BV_cell{:}]');
    for val = v_ival(1):range(v_ival)/10:v_ival(2)
        assert(A_poly.contains(vec(double(subs(subs(A, p, f), v, val)))));
        assert(B_poly.contains(vec(double(subs(subs(B, p, f), v, val)))));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Stabilize and discretize  %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% K = joint_stab(A_vertices, B, sanity_check);
K = zeros(1,4)

A_vertices_stable = cellfun(@(A) A-B*K, A_vertices, 'UniformOutput', 0);

A_vertices_discrete = cellfun(@(A) eye(4) + dt*A, A_vertices_stable, 'UniformOutput', 0);
B_vertices_discrete = cellfun(@(B) dt*B,          B_vertices, 'UniformOutput', 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Compute invariant set %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define safe sets
ymax = 0.9;
vmax = 1.2;
psimax = 0.05;
rmax = 0.3;
rdmax = pi*2/180;

C0 = Polyhedron('A', [eye(4); -eye(4)], ...
			   'b', [ymax; vmax; psimax; rmax; ymax; vmax; psimax; rmax]);
XUset = Polyhedron('H', [-K 1 rdmax; K -1 rdmax]);

C = C0;
iter = 0;
while not (C <= multi_pre_diffu(C, A_vertices_discrete, B_vertices_discrete, XUset, 0.0))
  Cpre = multi_pre_diffu(C, A_vertices_discrete, B_vertices_discrete, XUset, 0.02);
  C = Polyhedron('H', [Cpre.H; C0.H]); % intersect

  myMinHRep(C, size(Cpre.H,1)+1);

  iter = iter+1;
  disp(sprintf('\n'))
  disp(['iteration ', num2str(iter), ', ', num2str(size(C.A,1)), ' inequalities'])
end

save('simulation/safeset_lk.mat', 'C', 'con', 'func_poly', 'K', 'A_vertices_discrete')