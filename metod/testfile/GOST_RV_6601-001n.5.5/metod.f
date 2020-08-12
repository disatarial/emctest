
\ окно метода
VARIABLE builder_metod
VARIABLE WinMetod
VARIABLE button_close_metod


:NONAME 
	WinMetod @ 1 gtk_widget_destroy DROP  
\	builder_metod @ 1 gtk_widget_destroy DROP  	
	0 ;  1 CELLS  CALLBACK: on_metod_destroy  

:NONAME  
	WinMetod @ 1 gtk_widget_destroy DROP    
\	builder_metod @ 1 gtk_widget_destroy DROP  	
	0 ;  1 CELLS  CALLBACK: button_close_metod_click

: StartMetod  {   \ tekFile }
   Directory 2 + ASCIIZ>  "" DUP -> tekFile  STR+
  " /metod.glade" tekFile  S+
  tekFile STR@ TYPE CR
  0 gtk_builder_new   builder_metod !
   error  tekFile   >R R@ STR@  DROP  builder_metod @ 3 gtk_builder_add_from_file DROP   R> STRFREE \ 2DROP 
  " winmetod"  >R R@ STR@  DROP builder_metod @ 2 gtk_builder_get_object WinMetod !  R> STRFREE \ 2DROP
  WinMetod @  1 gtk_widget_show DROP \ DROP

   \ ДЕЙСТВО ЗАКРЫТИЕ ПРОГРАММЫ
   " destroy"  >R 0 0 0  ['] on_metod_destroy  R@ STR@ DROP WinMetod @ 6 g_signal_connect_data   R> STRFREE  DROP \ 2DROP 2DROP 2DROP

 " button_close" >R  R@ STR@  DROP builder_metod @ 2 gtk_builder_get_object button_close_metod  !    R> STRFREE \ 2DROP
  " clicked"  >R 0 0 0  ['] button_close_metod_click R@ STR@ DROP button_close_metod   @ 6 g_signal_connect_data   R> STRFREE  DROP \ 2DROP 2DROP 2DROP

;
















StartMetod