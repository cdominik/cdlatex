

README: cdlatex.el
	perl -ne 'if (/^;;; Commentary/../^;;;;;;;;;/) {s/^;;;? ?//;print}' cdlatex.el > README
