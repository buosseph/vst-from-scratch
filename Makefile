CC 			= clang++
CFLAGS 	= -Weverything
LIBS 		=

main :
	$(CC) $(CFLAGS) $(LIBS) -o main main.cpp

debug : 
	$(CC) $(CFLAGS) -g $(LIBS) -o main main.cpp

release : 
	$(CC) $(CFLAGS) -O3 $(LIBS) -o main main.cpp

clean :
	rm main