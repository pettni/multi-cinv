function con = constants

    % Common parameters
    con.m = 1650 ; %kg

    % ACC parameters
    con.f0bar = -24;
    con.f1bar = 19;

    % LK parameters
    con.Iz = 2315; % kgm^2
    con.a = 1.11; % m
    con.b = 1.59; % m
	con.Caf = 1.33e5; % N/rad 
    con.Car = 9.88e4; % N/rad
    
    % control bounds
    con.df_max = pi*2/180;
    con.fw_max = 2*con.m;
    con.fw_min = -3*con.m;

    % sampling time
    con.dt = 0.1;
    
 
    % For the LK simulation
    con.lk_data = load('safeset_lk');
    con.lk_init = [0.3 -0.5 0 0.2]';

    if ~con.lk_data.C.contains(con.lk_init)
    error('LK: initial point not in C')
    end

    % For the ACC simulation
    % con.acc_data = load('safeset_acc');
    con.acc_init = [29 50]';

    % if ~con.lk_data.C.contains(con.lk_init)
    % error('LK: initial point not in C')
    % end

end