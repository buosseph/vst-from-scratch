CC 			= clang++
CFLAGS 	= -Weverything
LIBS 		= # -lpng # (for gui support in the future)
DIRS		= # -I'/VST3 SDK/pluginterfaces/vst2.x/aeffect.h' \
					-I'/VST3 SDK/pluginterfaces/vst2.x/aeffectx.h'

main :
	$(CC) $(CFLAGS) $(DIRS) $(LIBS) -o main src/main.cpp

debug : 
	$(CC) $(CFLAGS) -g $(DIRS) $(LIBS) -o main src/main.cpp

release : 
	$(CC) $(CFLAGS) -O3 $(DIRS) $(LIBS) -o main src/main.cpp

clean :
	rm main