CC= c99
CFLAGS= -Wextra -pedantic -c
LDFLAGS=


all: ephemeride

ephemeride: date.o ephemeride.o
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	rm *.o ephemeride

.PHONY: all clean
# DO NOT DELETE

EDT.o: cours.h salle.h date.h enseignant.h
cours.o: cours.h salle.h date.h enseignant.h
date.o: date.h
enseignant.o: enseignant.h date.h
ephemeride.o: date.h
salle.o: salle.h date.h
