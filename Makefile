PLUGIN_NAME = plugin
VERSION 		= 0.1.0
AUTHOR			= yourname
VST_SDK 		= sdk/VST3_SDK
MIN_MAC_OSX = 10.7
	# Not sure if this works

CXX 				= clang++
CXXFLAGS 		= -std=c++11 -Weverything
SDKFLAGS		= -w -O2
OBJS				= $(PLUGIN_NAME).o vstplugmain.o audioeffect.o audioeffectx.o
LIBS				= -L. 
INCLUDES 		=	-I. \
							-I"$(VST_SDK)/pluginterfaces/vst2.x" \
							-I"$(VST_SDK)/public.sdk/source/vst2.x" \
							-I"$(VST_SDK)"
ENTRY 			= -e _VSTPluginMain
						# This is specific to the linker used on Macs `ld`
MAC_EXPORT	= -mmacosx-version-min=$(MIN_MAC_OSX) -bundle -o $(PLUGIN_NAME)
						# `-bundle` is also specific to `ld`
MAC_ARCHS		= -arch x86_64 -arch i386
LINK_TARGET = $(PLUGIN_NAME).vst

#WIN_TARGET	= -target i386-pc-win32
#WIN_EXPORT	= -o $(PLUGIN_NAME).dll

#WIN_EXPORT	= -DBUILDING_DLL -mwindows -O3
#WIN_LIBS		= -L. --add-stdcall-alias -lole32 -lkernel32 -lgdi32 \
#							-luuid -luser32 -mwindows --no-export-all-symbols \
#							--def $(PLUGIN_NAME).def

# Linker flag notes (man ld)
#	-bundle => produce a mach-o bundle (file type: MH_BUNDLE)
# -e symbol_name => Specifies the entry point of a main executable.
#		(default is start which belongs to main())

# Mac OS X VSTs:
# 
# On Mac OS X .vst files are actually bundles (e.g. Run `file Some.vst` 
# and you'll see it's actually a directory, the actual program insdie 
# will return something like 'Mach-O 64-bit bundle x86_64'). Bundles
# are directories with a standardized hierarchical structure
# containing executable code and resouces used by the program.
# For this reason, compiling the binary using this makefile is not
# enough for the plugin to be recognized by other programs.
# 
# Universal binaries contain binaries for multiple architectures.

all: $(LINK_TARGET)
	@echo Done

# Mac Bundle Export
$(LINK_TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -v -O2 $(ENTRY) $^ $(MAC_EXPORT)
	mkdir $@
	mkdir $@/Contents
	mkdir $@/Contents/Resources
	mkdir $@/Contents/MacOS
	mv $(PLUGIN_NAME) $@/Contents/MacOS/$(PLUGIN_NAME)
	./scripts/create_mac_info.sh $(PLUGIN_NAME) $(VERSION) $(AUTHOR)

# Untested
mac-universal:
	# Compile objects
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(MAC_ARCHS) -c \
	src/$(PLUGIN_NAME).cpp -o $(PLUGIN_NAME).o
	$(CXX) $(SDKFLAGS) $(INCLUDES) $(MAC_ARCHS) -c \
	$(VST_SDK)/public.sdk/source/vst2.x/vstplugmain.cpp \
	-o vstplugmain.o
	$(CXX) $(SDKFLAGS) $(INCLUDES) $(MAC_ARCHS) -c \
	$(VST_SDK)/public.sdk/source/vst2.x/audioeffect.cpp \
	-o audioeffect.o
	$(CXX) $(SDKFLAGS) $(INCLUDES) $(MAC_ARCHS) -c \
	$(VST_SDK)/public.sdk/source/vst2.x/audioeffectx.cpp \
	-o audioeffectx.o
	# Compile universal binary
	$(CXX) $(CXXFLAGS) -O2 $(ENTRY) $(OBJS) $(MAC_ARCHS) $(MAC_EXPORT)
	# Create bundle
	mkdir $(LINK_TARGET)
	mkdir $(LINK_TARGET)/Contents
	mkdir $(LINK_TARGET)/Contents/Resources
	mkdir $(LINK_TARGET)/Contents/MacOS
	mv $(PLUGIN_NAME) $(LINK_TARGET)/Contents/MacOS/$(PLUGIN_NAME)
	./scripts/create_mac_info.sh $(PLUGIN_NAME) $(VERSION) $(AUTHOR)


# Windows VSTs:
#
# On Windows VSTs are stored as .dll files.
# (`file plugin.dll` =>
# PE32 executable for MS Windows (DLL) (GUI) Intel 80386 32-bit)

#	win-export: $(OBJS) # don't use this...
#		dllwrap.exe --output-def lib$(PLUGIN_NAME).def --driver-name c++ \
#		--implib lib$(PLUGIN_NAME).a $^ $(LIBS) -o $(PLUGIN_NAME).dll
#		# OBJS should be compiled with these flags: -DBUILDING_DLL=1 -mwindows
# win:
# 	# Compile objects
# 	$(CXX) $(CXXFLAGS) $(INCLUDES) $(WIN_TARGET) -c \
# 	src/$(PLUGIN_NAME).cpp -o $(PLUGIN_NAME).o
# 	$(CXX) $(SDKFLAGS) $(INCLUDES) $(WIN_TARGET) -c \
# 	$(VST_SDK)/public.sdk/source/vst2.x/vstplugmain.cpp \
# 	-o vstplugmain.o
# 	$(CXX) $(SDKFLAGS) $(INCLUDES) $(WIN_TARGET) -c \
# 	$(VST_SDK)/public.sdk/source/vst2.x/audioeffect.cpp \
# 	-o audioeffect.o
# 	$(CXX) $(SDKFLAGS) $(INCLUDES) $(WIN_TARGET) -c \
# 	$(VST_SDK)/public.sdk/source/vst2.x/audioeffectx.cpp \
# 	-o audioeffectx.o
# 	# Compile dll
# 	$(CXX) $(CXXFLAGS) -O2 $(ENTRY) $(OBJS) $(WIN_TARGET) $(WIN_EXPORT)

debug: $(OBJS)
	$(CXX) $(CXXFLAGS) -O0 -g $(ENTRY) $^ $(MAC_EXPORT)

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
