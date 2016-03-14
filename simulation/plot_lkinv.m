% Plot the safe set

multiplier = 1.1;

ymax = multiplier*0.9;
numax = multiplier*1.2;
psimax = multiplier*0.05;
rmax = multiplier*0.3;

data = load('safeset_lk.mat');
figure(1); clf; 

extraoptions = 'scaled ticks=false, tick label style={/pgf/number format/fixed}, every axis z label/.style={at={(ticklabel* cs:1.05)}, anchor=south}, every axis x label/.style={at={(ticklabel* cs:1.05)}, anchor=west}, axis z line=left, axis x line=left';

plot(projection(data.C, [2 3 4]), 'alpha', 0.5)
xlabel('$\nu$'), ylabel('$\psi$'),zlabel('$r$')
xlim([-numax numax]), ylim([-psimax psimax]), zlim([-rmax rmax])
% set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_output/lk_inv1.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		     'extraAxisOptions', extraoptions)

plot(projection(data.C, [1 3 4]), 'alpha', 0.5)
xlabel('$y$'), ylabel('$\psi$'),zlabel('$r$')
xlim([-ymax ymax]), ylim([-psimax psimax]), zlim([-rmax rmax])
% set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_output/lk_inv2.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		     'extraAxisOptions', extraoptions)

plot(projection(data.C, [1 2 4]), 'alpha', 0.5)
xlabel('$y$'), ylabel('$\nu$'),zlabel('$r$')
xlim([-ymax ymax]), ylim([-numax numax]), zlim([-rmax rmax])
% set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_output/lk_inv3.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		     'extraAxisOptions', extraoptions)

plot(projection(data.C, [1 2 3]), 'alpha', 0.5)
xlabel('$y$'), ylabel('$\nu$'),zlabel('$\psi$')
xlim([-ymax ymax]), ylim([-numax numax]), zlim([-psimax psimax])
% set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_output/lk_inv4.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		     'extraAxisOptions', extraoptions)

% Plot the polyhedron in parameter space
clf; hold on

vrange = 25:0.01:30;

plot(data.func_poly, 'alpha', 0.3, 'linestyler', 'none')
plot(data.func_poly.V(:,1), data.func_poly.V(:,2), 'o', 'color', 'red', 'markersize', 6, 'MarkerFaceColor','red')
plot(1./vrange, vrange, 'b', 'linewidth', 2)

xlabel('$1/u$')
ylabel('$u$')

matlab2tikz('plot_output/funcpoly.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		    'extraAxisOptions', ...
		    'xmajorgrids=false, ymajorgrids=false, axis x line=bottom, axis y line=left, every axis x label/.style={at={(current axis.south east)},anchor=west},  every axis y label/.style={at={(current axis.north west)},anchor=south}')

