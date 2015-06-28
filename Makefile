PLUGIN_NAME = plugin
VST_SDK 		= VST3_SDK

CXX 			= clang++
CXXFLAGS 	= -Weverything -O3
SDKFLAGS	= -w
OBJS			= $(PLUGIN_NAME).o vstplugmain.o audioeffect.o audioeffectx.o
LIBS			= -L. 
					# --add-stdcall-alias -lole32 -lkernel32 -lgdi32 -luuid -luser32 --no-export-all-symbols
					# --def $(PLUGIN_NAME).def -mwindows
INCLUDES 	=	-I. \
						-I"$(VST_SDK)/pluginterfaces/vst2.x" \
						-I"$(VST_SDK)/public.sdk/source/vst2.x" \
						-I"$(VST_SDK)"

ENTRY 	= -Wl,-e createEffectInstance
MAC_EXPORT	= -dynamic -o $(PLUGIN_NAME).vst
LINK_TARGET = $(PLUGIN_NAME).vst

WIN_EXPORT	= -DBUILDING_DLL -mwindows -O3
WIN_LIBS		= -L. --add-stdcall-alias -lole32 -lkernel32 -lgdi32 \
							-luuid -luser32 -mwindows --no-export-all-symbols \
							--def $(PLUGIN_NAME).def

all: $(LINK_TARGET)
	echo Done

$(LINK_TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(ENTRY) -o $@ $^

# Experimental, untested
#	win-export: $(OBJS)
#		dllwrap.exe --output-def lib$(PLUGIN_NAME).def --driver-name c++ \
#		--implib lib$(PLUGIN_NAME).a $^ $(LIBS) -o $(PLUGIN_NAME).dll
#		# OBJS should be compiled with these flags: -DBUILDING_DLL=1 -mwindows

#debug : 
#	$(CXX) $(CXXFLAGS) -O0 -g $(VST_DSK) $(LIBS) $(MAC_EXPORT) $(ENTRY) src/plugin.cpp

#release : 
#	$(CXX) $(CXXFLAGS) -O3 $(VST_DSK) $(LIBS) $(MAC_EXPORT) $(ENTRY) src/plugin.cpp

objects: $(OBJS)

$(PLUGIN_NAME).o: src/$(PLUGIN_NAME).cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

vstplugmain.o: $(VST_SDK)/public.sdk/source/vst2.x/vstplugmain.cpp
	$(CXX) $(SDKFLAGS) $(INCLUDES) -c $< -o $@

audioeffect.o: $(VST_SDK)/public.sdk/source/vst2.x/audioeffect.cpp
	$(CXX) $(SDKFLAGS) $(INCLUDES) -c $< -o $@

audioeffectx.o: $(VST_SDK)/public.sdk/source/vst2.x/audioeffectx.cpp
	$(CXX) $(SDKFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm $(OBJS)