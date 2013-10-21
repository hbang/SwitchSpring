TARGET = simulator:clang

include theos/makefiles/common.mk

TWEAK_NAME = SwitchSpring
SwitchSpring_FILES = Tweak.x HBSSRespringAlertItem.x
SwitchSpring_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
