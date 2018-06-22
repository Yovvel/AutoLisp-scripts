;whats new?
;	- 


(defun JEN:new_drawing(filename img_ref)
	(command "undo" "mark")
	(command "_IMAGE" "_ATTACH" img_ref "0,0" "1" "0")
	(command "_save" filename)
	(command "undo" "back")
)

;!Work in progress; wordt een functie om op basis van het RLO/RTO nummer de juiste locatie te vinden.
;Tot die tijd, plaats hier handmatig de maplocatie in.
(defun JEN:get_working_directory(/ w_directory)
	;(setq w_directory "U:\\TEC\\PRO\\RLO\\1900\\1939 LiRTU13532 OS LW 110 kV RTU progr 2016\\Secundair\\11 Acad tekeningen\\03 In bewerking\\")
	(setq w_directory "C:\\TIFF-TEST\\")
)

(defun c:removeDWGdwg()
	(setq 	w_directory(JEN:get_working_directory)												; ontvang de juiste map om mee te werken
			maplijst (vl-directory-files w_directory "*" -1)									; zoek alle onderliggende mappen
	)
	(foreach map maplijst
		(princ "zoeken in ")(princ map)(princ "\n")												;!debug-regel
		(setq
				filelocation (strcat w_directory map)
				dwglist (vl-directory-files filelocation "*.dwg"))					;pak alle dwg bestanden in de map
		(princ "gevonden tekeningen: ")(princ dwglist)(princ "\n")								;!debug
		(foreach dwg dwglist
			(princ "tekening: ")(princ dwg)(princ "\n")																;!debug
			(setq 	dwgBase (vl-filename-base dwg)
					LastPartOfFile (substr dwgBase (- (strlen dwgBase) 3)))
			(princ "eindigd op: ")(princ LastPartOfFile)(princ "\n")								;!debug
			 

			(if (= (strcase LastPartOfFile) ".DWG")
				(progn
					(princ dwgBase) (princ " aanpassen")
					(vl-file-rename (strcat filelocation "\\" dwg) 	(strcat filelocation "\\" (vl-string-right-trim ".dwg" dwg)))									
					;(princ " naam aanpassen\n")(princ (strcat filelocation "\\" dwg))(princ "\n")
				)
				(princ " naam is goed\n")
			)
			(princ "\n")(princ)
		)
	)
)	

(defun c:test()
	(JEN:get_working_directory)
	(princ (strcat "locatie is\n " x " \n Yes het werkt!"))
	(princ)
)


(defun c:NEW_DWG_TIFF()
	(princ "---------------------------------------------------------------------------------\n")
	;keuze om ook de extra dwg text te verwijderen
	(while (
	(setq removeDWGYN(getstring  "Wil je de tekeningen controleren op een dubbele \"dwg\" tekst in de naam?<y,n>"))
	(if (= removeDWGYN "y")
		(c:removeDWGdwg)
		(princ "bestandsnamen worden niet gecontroleerd")
	)
	
	; verzamelen van alle tiffs in onderliggende mappen
	(setq	w_directory(JEN:get_working_directory)												; ontvang de juiste map om mee te werken
			maplijst (vl-directory-files w_directory "*" -1)									;zoek alle onderliggende mappen. 1e 2 ("." & "..") gebruiken we niet
			maplijst (vl-remove "." maplijst)													;en verwijderen we daarom gelijk uit onze lijst
			maplijst (vl-remove ".." maplijst)													;zodat we een schone lijst over houden om mee te werken !todo: misschien wel in de lijst houden voor de gevallen er geen aparte mappen zijn?
	)
	
	;ga per map de tiffs en dwg's met elkaar vergelijken
	(foreach map maplijst
		(setq 	tiflist (vl-directory-files (strcat w_directory map) "*.tif")					;pak alle tiff bestanden in de map
				dwglist (vl-directory-files (strcat w_directory map) "*.dwg"))					;pak alle dwg bestanden in de map
		(princ "zoeken in ")(princ map)(princ "\n")												;!debug-regel
		
		;ga elke tif apart vergelijken met de dwg tekeningen in de huidige map
		(foreach file_t tiflist																	; voor elke tif..
			(setq tifsufix(substr file_t 1(- (strlen file_t) 4)))								; verwijderen van file extentie ;!todo: gebruik functie vl-filename-base
			(if(vl-directory-files (strcat w_directory map) (strcat tifsufix ".dwg"))			; als T is dan..(als dwg in dezelfde map als tif met dezelfde naam gevonden wordt)
				(progn
					(princ "dwg found for ")(princ file_t)(princ "\n")							;!debug-regel
				)				
				(progn
					(princ file_t)(princ " heeft geen dwg\n")									;!debug-regel
					(setq 	dwgname(strcat w_directory map "\\" tifsufix ".dwg")
							img_ref(strcat tifsufix "=" w_directory map "\\" file_t))
					(princ "img_ref is : ")(princ img_ref)(princ "\n")
					(JEN:new_drawing dwgname img_ref)
				)
			)
		)
	(princ "\n")
	)
	(princ)
)
