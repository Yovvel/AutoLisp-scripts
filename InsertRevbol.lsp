(defun c:revbol()
	(setvar "attdia" 0)
	(setq	REVSTAND "A"
			REVDATUM "20.07.2018"
	)
	(command "_.insert" "_revbol" "400,37.5" "1" "1" "0" REVSTAND REVDATUM)
	(setvar "attdia" 1)
)
