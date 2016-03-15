function car(block)

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of dialog parameters   
  block.NumDialogPrms = 0;

  %% Register number of input and output ports
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = 4;
  block.InputPort(1).DirectFeedthrough = false;
  
  block.InputPort(2).Dimensions        = 2;
  block.InputPort(2).DirectFeedthrough = false;

  block.OutputPort(1).Dimensions       = 1;
  
  %% Set block sample time to inherited
  block.SampleTimes = [-1 0];
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
  
%endfunction

function InitConditions(block)
  global con;
  block.OutputPort(1).Data = con.lk_data.K*con.lk_init;
%endfunction

function Output(block)
  global con
  
  x_lk = block.InputPort(1).Data;
  x_acc = block.InputPort(2).Data;
  
  if ~con.lk_data.C.contains(x_lk)
    % We fell out of C, hopefully due to being in between sample times
    disp('warning: LK out of C')
    return
  end

  % get speed from acc state
  v = x_acc(1);
  
  if(v == 0)
      v = 27;
  end
  
  A = [0 1 v 0;
    0 -(con.Caf+con.Car)/(con.m*v) 0 ((con.b*con.Car-con.a*con.Caf)/(con.m*v) - v);
    0 0 0 1;
    0 (con.b*con.Car-con.a*con.Caf)/(con.Iz*v)  0 -(con.a^2 * con.Caf + con.b^2 * con.Car)/(con.Iz*v)];
  B = [0;con.Caf/con.m; 0; con.a*con.Caf/con.Iz];
  E = [0;0;1;0];
  K = [0;0;0;0];

  A = A*con.dt + eye(4);
  B = B*con.dt;
  E = E*con.dt;
  K = K*con.dt;
  
  if 1 % do some checks
    AV_cell = cellfun(@vec, con.lk_data.A_vertices_discrete, 'UniformOutput', false);
    A_poly = Polyhedron('V', [AV_cell{:}]');
    testnum = max(A_poly.A*vec(A) - A_poly.b);
    if testnum > 2e-5
      testnum
      con.lk_data.A_vertices_discrete{1}
      con.lk_data.A_vertices_discrete{2}
      con.lk_data.A_vertices_discrete{3}
      con.lk_data.A_vertices_discrete{4}
      assert(false);
    end
  end

  % assume no disturbance
  XD_plus = 0;
  XD_minus = 0;
  
  R_x = diag([1 0 0 0]);
  r_x = [0; 0; 0; 0;];
  R_u = 1;
  r_u = 0;

  H_x = con.lk_data.C.A;
  h_x = con.lk_data.C.b;

  H = B'*R_x*B + R_u;
  f = r_u + B'*R_x*(A*x_lk + K) + B'*r_x;
  A_constr = [H_x*B; H_x*B; 1; -1];
  b_constr = [h_x - H_x*A*x_lk - H_x*E*XD_plus; 
            h_x - H_x*A*x_lk - H_x*E*XD_minus;
            con.df_max;
            con.df_max];

  [u, ~, flag] = quadprog(H, f, A_constr, b_constr);

  % Assert feasible
  assert(flag == 1)

  block.OutputPort(1).Data = u;
  
%endfunction