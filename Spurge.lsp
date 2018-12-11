(defun c:SPURGE()
	(command "_.PURGE" "_ALL" "*" "_N")
	(while
		(progn
			(command "._PURGE" "_All" "*" "_YES")
			(while (= (getvar "CMDACTIVE") 1) (command "_YES") T)
		)
	)
	(princ)
)
