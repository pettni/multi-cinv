data = load('lk_invariant_newparam');
figure(1); clf; 

plot(projection(data.C, [2 3 4]), 'alpha', 0.5)
xlabel('$\nu$'), ylabel('$\psi$'),zlabel('$r$')
set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_sets1.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false)

plot(projection(data.C, [1 3 4]), 'alpha', 0.5)
xlabel('$y$'), ylabel('$\psi$'),zlabel('$r$')
set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_sets2.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false)

plot(projection(data.C, [1 2 4]), 'alpha', 0.5)
xlabel('$y$'), ylabel('$\nu$'),zlabel('$r$')
set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_sets3.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false)

plot(projection(data.C, [1 2 3]), 'alpha', 0.5)
xlabel('$y$'), ylabel('$\nu$'),zlabel('$\psi$')
set(gca,'xtick',[], 'ytick', [], 'ztick', [])
matlab2tikz('plot_sets4.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false)
