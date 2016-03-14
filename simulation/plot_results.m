% Plot results of Simulink experiments
con = constants;
linewidth = 1.5;

figure(1); clf
subplot(411); hold on
plot(x_acc.Time, x_acc.Data(:,1), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [25 25], 'g--'); plot(xl, [30 30], 'g--')
ylim([1/1.1*25, 1.1*30])
ylabel('$v$')
set(gca,'xtick',[])

subplot(412); hold on
plot(x_acc.Time, x_acc.Data(:,2), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [40 40], 'g--');
ylim([30 80])
ylabel('$h$')
set(gca,'xtick',[])

subplot(413); hold on
plot(u_acc.Time, u_acc.Data(:,1)./(con.m*9.82), 'r', 'linewidth', linewidth)
xl = xlim; plot(xl, [con.fw_min/(con.m*9.82) con.fw_min/(con.m*9.82)], 'g--'); plot(xl, [con.fw_max/(con.m*9.82) con.fw_max/(con.m*9.82)], 'g--')
ylim([1.1*con.fw_min/(con.m*9.82), 1.1*con.fw_max/(con.m*9.82)])
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
xl = xlim; plot(xl, [0.9 0.9], 'g--'); plot(xl, [-0.9 -0.9], 'g--')
ylim([-1.1*0.9, 1.1*0.9])
ylabel('$y$')
set(gca,'xtick',[])

subplot(412); hold on
plot(x_lk.Time, x_lk.Data(:,2), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [1.2 1.2], 'g--'); plot(xl, [-1.2 -1.2], 'g--')
ylim([-1.1*1.2, 1.1*1.2])
ylabel('$\nu$')
set(gca,'xtick',[])

subplot(413); hold on
plot(x_lk.Time, x_lk.Data(:,3), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [0.05 0.05], 'g--'); plot(xl, [-0.05 -0.05], 'g--')
ylim([-1.1*0.05, 1.1*0.05])
ylabel('$\Psi$')
set(gca,'xtick',[])

subplot(414); hold on
plot(x_lk.Time, x_lk.Data(:,4), 'b', 'linewidth', linewidth)
xl = xlim; plot(xl, [0.3 0.3], 'g--'); plot(xl, [-0.3 -0.3], 'g--')
ylim([-1.1*0.3, 1.1*0.3])
ylabel('$r$')
xlabel('$t$')

matlab2tikz('plot_output/sim_lk.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		    'extraAxisOptions', ...
		    'scaled ticks=false, tick label style={/pgf/number format/fixed}, xmajorgrids=false, ymajorgrids=false, axis x line=bottom, axis y line=left, every axis x label/.style={at={(current axis.south east)},anchor=west}')
