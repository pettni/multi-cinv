function car(block)

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of dialog parameters   
  block.NumDialogPrms = 0;

  %% Register number of input and output ports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = 1;
  block.InputPort(1).DirectFeedthrough = false;

  block.InputPort(2).Dimensions        = 1;
  block.InputPort(2).DirectFeedthrough = false;

  block.InputPort(3).Dimensions        = 4;
  block.InputPort(3).DirectFeedthrough = false;

  block.OutputPort(1).Dimensions       = 2;
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 2;

  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Derivatives',             @Derivative);  
  
%endfunction

function InitConditions(block)
  global con
  block.ContStates.Data = con.acc_init; % initial condition
  block.OutputPort(1).Data = con.acc_init;
  
%endfunction

function Output(block)
  block.OutputPort(1).Data = block.ContStates.Data;

%endfunction

function Derivative(block)
  global con;

  vl = 27;

  u = block.InputPort(1).Data;
  d = block.InputPort(2).Data;
  
  x_acc = block.ContStates.Data;
  x_lk = block.InputPort(3).Data;

  A = [-con.f1bar/con.m 0; -1 0];
  B = [1/con.m; 0];
  E = [0;1];
  K = [-con.f0bar/con.m - x_lk(2)*x_lk(4); vl];

  block.Derivatives.Data = A*x_acc + B*u + E*d + K;
  
%endfunction

