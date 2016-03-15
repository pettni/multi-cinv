function con = constants

	% Common parameters
    con.m = 1650 ; %kg

    % ACC parameters
    con.f0bar = -24;
    con.f1bar = 19;

    % ACC bounds
    con.u_min = 25;
    con.u_max = 30;
    con.h_min = 42;
    con.vl = 26;

    con.Fw_max = 2*con.m;
    con.Fw_min = -3*con.m;

    % LK parameters
    con.Iz = 2315; % kgm^2
    con.a = 1.11; % m
    con.b = 1.59; % m
	con.Caf = 1.33e5; % N/rad 
    con.Car = 9.88e4; % N/rad

    % LK bounds
    con.y_max = 0.9;
    con.nu_max = 1.2;
    con.psi_max = 0.05;
    con.r_max = 0.3;
    
    con.df_max = pi*2/180;   % control
    con.rd_max = 0.05;       % disturbance

    % Time discretization
    con.dt = 0.1;

end