function con = constants

    % Load synthesis constants
    cd ..
    con = constants;
    cd simulation 
 
    % For the LK simulation
    con.lk_data = load('safeset_lk');
    con.lk_init = [0.3 -0.5 0 0.2]';

    if ~con.lk_data.C.contains(con.lk_init)
        error('LK: initial point not in C')
    end

    % For the ACC simulation
    con.acc_data = load('safeset_acc');
    con.acc_init = [29 50]';

    if ~con.acc_data.C.contains(con.acc_init)
        error('ACC: initial point not in C')
    end

end