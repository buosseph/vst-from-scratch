#ifndef PLUGIN_H
#define PLUGIN_H

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundef"
#pragma clang diagnostic ignored "-Wpadded"
#pragma clang diagnostic ignored "-Wshadow"
#pragma clang diagnostic ignored "-Wold-style-cast"
#pragma clang diagnostic ignored "-Wdocumentation-unknown-command"
#pragma clang diagnostic ignored "-Wunused-parameter"

#include "audioeffectx.h"

#include "public.sdk/source/vst2.x/vstplugmain.cpp"

#pragma clang diagnostic pop

// List all user parameters here. This is used for indexing.
enum {
  // param1 = 0,
  numParameters
};

const int numPrograms = 0;  // Set number of preset porgrams
const int numInputs   = 2;  // Set number of input channels
const int numOutputs  = 2;  // Set number of output channels

class VstPlugin: public AudioEffectX {
public:
  VstPlugin(audioMasterCallback audioMaster);
  ~VstPlugin();

  // Plugin Properties (From AudioEffectX)
  virtual VstInt32        canDo(char* text);            // Reports what the plug-in is able to do
  virtual bool            getEffectName(char* name);    // Plugin name provided to host
  virtual VstPlugCategory getPlugCategory();            // Specify a category that fits the plug
  virtual bool            getProductString(char* text); // identifying the product name
  virtual bool            getVendorString(char* text);  // identifying the vendor
  virtual VstInt32        getVendorVersion();           // Returns vendor-specific version number

  virtual void  processReplacing(float** inputs, float** outputs, VstInt32 sampleFrames);

  /*
  // These are not extended from AudioEffectX 
  virtual float getParameter(VstInt32 index);
  virtual void  getParameterDisplay(VstInt32 index, char* text);
  virtual void  getParameterLabel(VstInt32 index, char* label);
  virtual void  getParameterName(VstInt32 index, char* text);
  virtual void  getProgramName(char *name);

  virtual void  setParameter(VstInt32 index, float value);
  virtual void  setProgramName(char* name);
  */
};
#endif
