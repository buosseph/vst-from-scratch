#include "plugin.h"

AudioEffect* createEffectInstance(audioMasterCallback audioMaster) {
  return new VstPlugin(audioMaster);
}

VstPlugin::VstPlugin(audioMasterCallback audioMaster)
  : AudioEffectX(audioMaster, numPrograms, numParameters)
{
  // Initalize plugin 
}

VstPlugin::~VstPlugin(){}

VstInt32 VstPlugin::canDo(char* text) {
  return 0;
}
bool VstPlugin::getEffectName(char* name) {
  return true;
}
VstPlugCategory VstPlugin::getPlugCategory() {
  return kPlugCategEffect;  // Numerous values, like this, delcared in pluginterfaces/vst2.x/aeffectx.h
}
bool VstPlugin::getProductString(char* text) {
  return true;
}
bool VstPlugin::getVendorString(char* text) {
  return true;
}
VstInt32 VstPlugin::getVendorVersion() {
  return 0;
}

void  VstPlugin::processReplacing(float** inputs, float** outputs, VstInt32 sampleFrames) {
  // Aw yeah. Time to do some processing!
}
