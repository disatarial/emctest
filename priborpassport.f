

: LOAD_TO_BUFER { s-adr adr \ u   -- }
." LOAD_TO_BUFER= " s-adr STR@  TYPE CR
s-adr STR@  DUP 255 > IF DROP 255 THEN -> u
adr  1+ u CMOVE 
s-adr STRFREE
u adr  C!
;
\ параметры приборов
 0
 128 CELLS --  NamePribor	\  назвавние прибора , либо имя файла
  1 FLOATS  -- FREQ_MIN   \ минимальая частота
  1 FLOATS  -- FREQ_MAX  \ максимальная частота
  1 FLOATS  -- LEVEL_MAX   \ максимальная уровень
 128 CELLS -- interface_data1	\  данные 1 для запуска интерфейса 
 128 CELLS -- interface_data2	\  данные 2 для запуска интерфейса 
\ ---------- внутрение данные--------------
64 CELLS -- Nameinterface	\  название интерфейса < com,tcpip,gpib....> 
256 CELLS -- interface	\  имя файла интерфейса < com,tcpip,gpib....> 
256 CELLS -- priborpath	\  имя файла этого! файла
CONSTANT PriborPassport 

 0 VALUE PriborPassport_info \ параметры оборудования
 
 HERE DUP >R PriborPassport DUP ALLOT ERASE TO PriborPassport_info

\ STR>S  PriborPassport_info priborpath LOAD_TO_BUFER   \ запомнили путь к прибору который пришел из прошлого файла

: PriborPassportSeeOne
\ :NONAME \ PriborPassportSeeOne \ подготовить в выводу описание переменной из настроек
{ n } \ < n -- num/fnum  flag adr u    | flag >
\ flag:   0 - нет описания 1 - целое 2-действительное 3- строка 4 -имя файла  калибровки, 5 -имя файла  прибора
\ < если отричательные значения - нередактируемое поле>
\ CASE
 0
n 0 = IF DROP PriborPassport_info  NamePribor	3	S" Название прибора "  THEN
n 1 = IF DROP PriborPassport_info FREQ_MIN	2	S" Минимальая частота, Гц "  THEN
n 2 = IF DROP PriborPassport_info FREQ_MAX	2	S" максимальная частота, Гц"  THEN
n 3 = IF DROP PriborPassport_info LEVEL_MAX     2	S" Максимальный уровень, дБмВт "  THEN
 n 4 = IF DROP PriborPassport_info interface	5	S" Путь к файлу интерфейса "  THEN
 n 5 = IF DROP PriborPassport_info Nameinterface	3	S" Название интерфейса "  THEN
 n 6 = IF DROP PriborPassport_info interface_data1	3	S" адрес"  THEN
 n 7 = IF DROP PriborPassport_info interface_data2	1	S" порт"  THEN

\ n 4 = IF DROP PriborPassport_info kalibrovka	4	S" Калибровочные <поправочные> данные, дБ "  THEN
\ n 10 = IF DROP   metod-info interface   3	S" ТИП интерфейса: <-1>-COM, <0>-TCPIP, <1>-GPIB<NI>, <2>-GPIB<AGILENT> "  THEN
; \  TO PriborPassportSeeOne
\ отладочная информация


: Save_PriborPassport
\ :NONAME  \ Save_PriborPassport \
{ save_file } \ сохранение настроек
." SAVE_PriborPassport " CR
 	PriborPassport_info	FREQ_MIN	F@ save_file FtoFile  "  PriborPassport_info FREQ_MIN			F! "  save_file StoFile  save_file CRtoFile	
	PriborPassport_info	FREQ_MAX	F@ save_file FtoFile  "  PriborPassport_info FREQ_MAX			F! "  save_file StoFile  save_file CRtoFile
	PriborPassport_info	LEVEL_MAX	F@ save_file FtoFile  "  PriborPassport_info LEVEL_MAX			F! "  save_file StoFile  save_file CRtoFile
\ имена файлов
	"  {''} " save_file StoFile PriborPassport_info	NamePribor  1 +	PriborPassport_info	NamePribor	C@ STR>S save_file StoFile  " {''} PriborPassport_info NamePribor	LOAD_TO_BUFER " save_file StoFile  save_file CRtoFile
\	"  {''} " save_file StoFile PriborPassport_info	kalibrovka	1 +	PriborPassport_info	kalibrovka	C@ STR>S save_file StoFile  " {''} PriborPassport_info kalibrovka	LOAD_TO_BUFER " save_file StoFile  save_file CRtoFile
	"  {''} " save_file StoFile PriborPassport_info	interface	1 +	PriborPassport_info	interface	C@ STR>S save_file StoFile  " {''} PriborPassport_info interface	LOAD_TO_BUFER " save_file StoFile  save_file CRtoFile
	"  {''} " save_file StoFile PriborPassport_info	Nameinterface	1 +	PriborPassport_info	Nameinterface	C@ STR>S save_file StoFile  " {''} PriborPassport_info Nameinterface	LOAD_TO_BUFER " save_file StoFile  save_file CRtoFile

	"  {''} " save_file StoFile PriborPassport_info	interface_data1 1 +	PriborPassport_info	interface_data1	C@ STR>S save_file StoFile  " {''} PriborPassport_info interface_data1	LOAD_TO_BUFER " save_file StoFile  save_file CRtoFile
	PriborPassport_info	interface_data2	 @ save_file DtoFile  "  PriborPassport_info interface_data2		! "   save_file StoFile  save_file CRtoFile	

; \ TO 	Save_PriborPassport 
	
:  FileInterface
\ :NONAME   
PriborPassport_info	interface 1+  ; \ TO FileInterface

: SaveInterface
\ :NONAME ( s -- \ )    
PriborPassport_info interface	LOAD_TO_BUFER  ; \ TO  SaveInterface

: PriborPassportSee { I }
0 -> I
 BEGIN
   I PriborPassportSeeOne  ."  PriborPassportSeeOne: " DUP . ." " 
 DUP  0 >  
 WHILE
       TYPE ." -> " CR
      2DROP
    I 1 + -> I
."  I: " I . ."  " CR
REPEAT
DEPTH .
DROP ;