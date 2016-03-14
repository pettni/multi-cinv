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

%endfunction

function Output(block)
  global con
  
  x_lk = block.InputPort(1).Data;
  x_acc = block.InputPort(2).Data;
  
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
  
  % assume no disturbance
  XD_plus = 0;
  XD_minus = 0;
  
  R_x = eye(4);
  r_x = [1; 1; 1; 1;];
  R_u = 1;
  r_u = 1;

  H_x = con.lk_data.C.A;
  h_x = con.lk_data.C.b;

  H = B'*R_x*B + R_u;
  f = r_u + B'*R_x*(A*x_lk + K) + B'*r_x;
  A_quad = [H_x*B; H_x*B];
  b_quad = [h_x - H_x*A*x_lk - H_x*E*XD_plus; h_x - H_x*A*x_lk - H_x*E*XD_minus];

  u = quadprog(H, f, A_quad, b_quad);
  
  if(size(u) == 0)
      u = -0.1*(x_lk(1));
  end
  
  block.OutputPort(1).Data = u;
  
%endfunction