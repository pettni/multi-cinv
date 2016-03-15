% Plot the safe set

con = constants;

data = load('safeset_acc.mat');
figure(1); clf; 

extraoptions = 'every axis x label/.style={at={(ticklabel* cs:1.05)}, anchor=west}, every axis y label/.style={at={(ticklabel* cs:1.05)}, anchor=south}, axis x line=left, axis y line=left';

plot(data.C, 'alpha', 0.5)
xlabel('$u$'), ylabel('$h$')
xlim([24.5 30.5]), ylim([40 65])
% set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_output/acc_inv.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		     'extraAxisOptions', extraoptions)

