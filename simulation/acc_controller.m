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
 
  block.InputPort(1).Dimensions        = 2;
  block.InputPort(1).DirectFeedthrough = false;
  
  block.InputPort(2).Dimensions        = 4;
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
  global con

  % block.OutputPort(1).Data = con.f0bar+con.f1bar*27;
  
  block.OutputPort(1).Data = con.f0bar+con.f1bar*27;
  
%endfunction

function Output(block)
  global con

  x_acc = block.InputPort(1).Data;
  x_lk = block.InputPort(2).Data;
  
  if(x_acc(1) == 0 && x_acc(2) == 0)
      x_acc = [27 60]';
  end
  
  % assume fixed lead car speed
  vl = 27.5;
  
  A = [-con.f1bar/con.m 0; -1 0];
  B = [1/con.m; 0];
  E = [0;1];
  K = [-con.f0bar/con.m - x_lk(2)*x_lk(4); vl];
  
  % assume /nu /r term is zero for simplicity
  
  A = A*con.dt + eye(2);
  B = B*con.dt;
  E = E*con.dt;
  K = K*con.dt;
  
  % assume no disturbances
  XD_plus = 0;
  XD_minus = 0;
  
  % desired velocity
  v_d = 29;
  
  % gain
  g = 100;
  
  R_x = [g 0; 0 0]; % don't care to minimize headway
  r_x = [-v_d*g; 0];
  R_u = 0;
  r_u = 0;

  H_x = con.acc_data.C.A;
  h_x = con.acc_data.C.b;

  H = B'*R_x*B + R_u;
  f = r_u + B'*R_x*(A*x_acc+K) + B'*r_x;

  A_constr = [H_x*B; H_x*B; 1; -1];
  b_constr = [h_x - H_x*A*x_acc - H_x*K - H_x*E*XD_plus;
                h_x - H_x*A*x_acc - H_x*K - H_x*E*XD_minus;
                con.fw_max;
                -con.fw_min];

  [u, ~, flag] = quadprog(H, f, A_constr, b_constr);
  
  % Assert feasible
  assert(flag == 1)
  
  block.OutputPort(1).Data = u;

%endfunction