CC 			= clang++
CFLAGS 	= -Weverything
LIBS 		= # -lpng # (for gui support in the future)
VST_DSK	= -I"VST3 SDK/pluginterfaces/vst2.x/affect.h" \
					-I"VST3 SDK/pluginterfaces/vst2.x/affectx.h" \
					-I"VST3 SDK/public.sdk/source/vst2.x/audioeffectx.h"
EXPORT	= 
ENTRY 	= -e createEffectInstance
PLUGIN_NAME = my_plugin

plugin :
	$(CC) $(CFLAGS) $(VST_DSK) $(LIBS) -o $(PLUGIN_NAME) $(ENTRY) src/plugin.cpp

debug : 
	$(CC) $(CFLAGS) -O0 -g $(VST_DSK) $(LIBS) -o $(PLUGIN_NAME) $(ENTRY) src/plugin.cpp

release : 
	$(CC) $(CFLAGS) -O3 $(VST_DSK) $(LIBS) -o $(PLUGIN_NAME) $(ENTRY) src/plugin.cpp

clean :
	rm plugin