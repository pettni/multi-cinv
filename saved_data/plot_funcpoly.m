clf; hold on

vrange = 25:0.01:30;

plot(func_poly, 'alpha', 0.3, 'linestyler', 'none')
plot(func_poly.V(:,1), func_poly.V(:,2), 'o', 'color', 'red', 'markersize', 6, 'MarkerFaceColor','red')
plot(1./vrange, vrange, 'b', 'linewidth', 2)

xlabel('$1/u$')
ylabel('$u$')

matlab2tikz('funcpoly.tikz','interpretTickLabelsAsTex',true, ...
		     'width','\figurewidth', 'height', '\figureheight', ...
		     'parseStrings',false, 'showInfo', false, ...
		    'extraAxisOptions', ...
		    'xmajorgrids=false, ymajorgrids=false, axis x line=bottom, axis y line=left, every axis x label/.style={at={(current axis.south east)},anchor=west},  every axis y label/.style={at={(current axis.north west)},anchor=south}')
