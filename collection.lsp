(defun c:C()
	(while 
		(command "copy")
	)

	(princ)
)

(defun C:ac()
	(setvar "chammode" 0)
	(setvar "chamfera" 2.5)
	(setvar "chamferb" 2.5)
	(setvar "chamferc" 2.5)
	(command "chamfer" pause pause)
	(command "trim" "" pause "")
)

(defun c:ZA()(command "ZOOM" "A"))
