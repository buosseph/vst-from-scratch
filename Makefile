PLUGIN_NAME = plugin
VERSION 		= 0.1.0
AUTHOR			= yourname
VST_SDK 		= sdk/VST3_SDK

CXX 				= clang++
CXXFLAGS 		= -Weverything
SDKFLAGS		= -w -O2
OBJS				= $(PLUGIN_NAME).o vstplugmain.o audioeffect.o audioeffectx.o
LIBS				= -L. 
INCLUDES 		=	-I. \
							-I"$(VST_SDK)/pluginterfaces/vst2.x" \
							-I"$(VST_SDK)/public.sdk/source/vst2.x" \
							-I"$(VST_SDK)"
ENTRY 			= -e _VSTPluginMain
						# Try -Wl,-e_VSTPluginMain if it doesn't seem to be working
MAC_EXPORT	= -bundle -o $(PLUGIN_NAME)
LINK_TARGET = $(PLUGIN_NAME).vst

#WIN_EXPORT	= -DBUILDING_DLL -mwindows -O3
#WIN_LIBS		= -L. --add-stdcall-alias -lole32 -lkernel32 -lgdi32 \
#							-luuid -luser32 -mwindows --no-export-all-symbols \
#							--def $(PLUGIN_NAME).def

# clang++ flag notes (man clang++)
# -fms-extensions => Enable support for Microsoft extensions
# -arch ___ => Specify architecture to build for
#		or -march=cpu => Generate code for specific processor family member and later
# -mmacosx-version-min=version => When building for Mac OS X, specify minimum version supported by application
# -Wl,args => Pass comma separated args to linker
#		or -Xlinker arg => Pass single arg to linker

# Linker flag notes (man ld)
#	-bundle => produce a mach-o bundle (file type: MH_BUNDLE)
# -e symbol_name => Specifies the entry point of a main executable.
#		(default is start which belongs to main())

# Note:
# On Mac OS X .vst files are actually bundles (e.g. Run `file Some.vst` 
# and you'll see it's actually a directory, the actual program insdie 
# will return something like 'Mach-O 64-bit bundle x86_64').
#
# Bundles are directories with a standardized hierarchical structure
# containing executable code and resouces used by the program.
# For this reason, compiling the binary using this makefile is not
# enough for the plugin to be recognized by other programs.
# 

all: $(LINK_TARGET)
	@echo Done

# Mac Bundle Export
$(LINK_TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -O2 $(ENTRY) $^ $(MAC_EXPORT)
	mkdir $@
	mkdir $@/Contents
	mkdir $@/Contents/Resources
	mkdir $@/Contents/MacOS
	mv $(PLUGIN_NAME) $@/Contents/MacOS/$(PLUGIN_NAME)
	./scripts/create_mac_info.sh $(PLUGIN_NAME) $(VERSION) $(AUTHOR)

debug: $(OBJS)
	$(CXX) $(CXXFLAGS) -O0 -g $(ENTRY) $^ $(MAC_EXPORT)

release: $(OBJS)
	$(CXX) $(CXXFLAGS) -O2 $(ENTRY) $^ $(MAC_EXPORT)
	@echo Done

# Experimental, untested
#	win-export: $(OBJS)
#		dllwrap.exe --output-def lib$(PLUGIN_NAME).def --driver-name c++ \
#		--implib lib$(PLUGIN_NAME).a $^ $(LIBS) -o $(PLUGIN_NAME).dll
#		# OBJS should be compiled with these flags: -DBUILDING_DLL=1 -mwindows

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
	rm -R $(LINK_TARGET) $(OBJS)

clean-objects:
	rm $(OBJS)
