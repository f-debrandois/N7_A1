ADA_EXERCICES = ${HOME}/ens/Ada/exercices/
PRECEDENT =	\
	${ADA_EXERCICES}	\
	${HOME}/ens/Ada/solutions/divers/REPOSITORY/	\
	${HOME}/ens/Ada/solutions/dbc-tester/REPOSITORY/	\

COPIES = \
	comprendre_mode_parametre.adb	\
	specifier_et_tester.adb	\
	puissance.adb	\

EMPTY_FILES = \
	dates.adb	\

DEDUITS = \
	${EMPTY_FILES}	\
	premier_programme.adb	\


FILTRE_CMD = 	\
	xcfiltre -SOLUTION	\
	| expand -t 4	\
	| recodeIfRequired.sh utf8	\

all:: generes

include ${HOME}/usr/make/generes.make

premier_programme.adb: ${ADA_EXERCICES}/premier_programme.adb
	cat $<	\
	    | sed -e 's/\<is\>/in/g'	\
	    | sed -e 's/Premier_Programme;/Premier_Programme./g'	\
	    | expand -t 4	\
	    > $@

${EMPTY_FILES}:
	touch $@
