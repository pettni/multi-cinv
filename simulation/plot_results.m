% Plot results of Simulink experiments
con = constants;
linewidth = 1.5;

figure(1); clf
subplot(411); hold on
plot(x_acc.Time, x_acc.Data(:,1), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.u_min con.u_min], 'g--'); plot(xl, [con.u_max con.u_max], 'g--')
ylim([24, 31])
ylabel('$v$')
set(gca,'xtick',[])

subplot(412); hold on
plot(x_acc.Time, x_acc.Data(:,2), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.h_min con.h_min], 'g--');
ylim([35 60])
ylabel('$h$')
set(gca,'xtick',[])

subplot(413); hold on
plot(u_acc.Time, u_acc.Data(:,1)./(con.m*9.82), 'r', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.Fw_min/(con.m*9.82) con.Fw_min/(con.m*9.82)], 'g--'); plot(xl, [con.Fw_max/(con.m*9.82) con.Fw_max/(con.m*9.82)], 'g--')
ylim([1.1*con.Fw_min/(con.m*9.82), 1.1*con.Fw_max/(con.m*9.82)])
ylabel('$F_w/mg$')
set(gca,'xtick',[])

subplot(414); hold on
plot(u_lk.Time, u_lk.Data, 'r', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.df_max con.df_max], 'g--'); plot(xl, [-con.df_max -con.df_max], 'g--')
ylim([-1.1*con.df_max, 1.1*con.df_max])
ylabel('$\delta_f$')
xlabel('$t$')

matlab2tikz('plot_output/sim_acc.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		    'extraAxisOptions', ...
		    'scaled ticks=false, tick label style={/pgf/number format/fixed}, xmajorgrids=false, ymajorgrids=false, axis x line=bottom, axis y line=left, every axis x label/.style={at={(current axis.south east)},anchor=west}')


figure(2); clf
subplot(411); hold on
plot(x_lk.Time, x_lk.Data(:,1), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.y_max con.y_max], 'g--'); plot(xl, [-con.y_max -con.y_max], 'g--')
ylim([-1.1*con.y_max, 1.1*con.y_max])
ylabel('$y$')
set(gca,'xtick',[])

subplot(412); hold on
plot(x_lk.Time, x_lk.Data(:,2), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.nu_max con.nu_max], 'g--'); plot(xl, [-con.nu_max -con.nu_max], 'g--')
ylim([-1.1*con.nu_max, 1.1*con.nu_max])
ylabel('$\nu$')
set(gca,'xtick',[])

subplot(413); hold on
plot(x_lk.Time, x_lk.Data(:,3), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.psi_max con.psi_max], 'g--'); plot(xl, [-con.psi_max -con.psi_max], 'g--')
ylim([-1.1*con.psi_max, 1.1*con.psi_max])
ylabel('$\Psi$')
set(gca,'xtick',[])

subplot(414); hold on
plot(x_lk.Time, x_lk.Data(:,4), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.r_max con.r_max], 'g--'); plot(xl, [-con.r_max -con.r_max], 'g--')
ylim([-1.1*con.r_max, 1.1*con.r_max])
ylabel('$r$')
xlabel('$t$')

matlab2tikz('plot_output/sim_lk.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		    'extraAxisOptions', ...
		    'scaled ticks=false, tick label style={/pgf/number format/fixed}, xmajorgrids=false, ymajorgrids=false, axis x line=bottom, axis y line=left, every axis x label/.style={at={(current axis.south east)},anchor=west}')
