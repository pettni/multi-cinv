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
  
  % if(x_acc(1) == 0 && x_acc(2) == 0)
  %     x_acc = [27 60]';
  % end
  
  % % assume fixed lead car speed
  % vl = 27;
  
  % A = [-con.f1bar/con.m 0; -1 0];
  % B = [1/con.m; 0];
  % E = [0;1];
  % K = [-con.f0bar/con.m - x_lk(2)*x_lk(4); vl];
  
  % % assume /nu /r term is zero for simplicity
  
  % A = A*con.dt + eye(2);
  % B = B*con.dt;
  % E = E*con.dt;
  % K = K*con.dt;
  
  % % assume no disturbances
  % XD_plus = 0;
  % XD_minus = 0;
  
  % R_x = eye(2);
  % r_x = [1; 1];
  % R_u = 1;
  % r_u = 1;

  % H_x = con.acc_data.A;
  % h_x = con.acc_data.b;

  % H = B'*R_x*B + R_u;
  % f = r_u + B'*R_x*(A*x_acc + K) + B'*r_x;
  % A_quad = [H_x*B; H_x*B; con.acc_Hu];
  % b_quad = [h_x - H_x*A*x_acc - H_x*E*XD_plus; h_x - H_x*A*x_acc - H_x*E*XD_minus;
  %           con.acc_hu];

  % u = quadprog(H, f, A_quad, b_quad);
  
  % if(size(u) == 0)
      u = con.f0bar+con.f1bar*27 + 200*(27-x_acc(1));
  % end
  
  block.OutputPort(1).Data = u;

%endfunction