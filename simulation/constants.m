function con = constants

    % Common parameters
    con.m = 1650 ; %kg

    % ACC parameters
    con.f0bar = -189;
    con.f1bar = 383;

    % LK parameters
    con.Iz = 2315; % kgm^2
    con.a = 1.11; % m
    con.b = 1.59; % m
	con.Caf = 1.33e5; % N/rad 
    con.Car = 9.88e4; % N/rad
    
    % sampling time
    con.dt = 0.1;
    
    A =   [ 1.0000         0;
           -1.0000         0;
                 0   -1.0000;
            0.1960   -0.9806;
            0.0995   -0.9950;
            0.2870   -0.9579;
            0.3708   -0.9287;
            0.4464   -0.8948;
            0.5134   -0.8581;
            0.5721   -0.8202];
    
  b = [];
  
  con.acc_data = Polyhedron(A,b);
  
  con.lk_data = load('lk_invariant');
  
end