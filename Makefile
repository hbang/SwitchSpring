include theos/makefiles/common.mk

TWEAK_NAME = SwitchSpring
SwitchSpring_FILES = Tweak.x HBSSRespringAlertItem.xm
SwitchSpring_FRAMEWORKS = UIKit CoreGraphics
SwitchSpring_CFLAGS = -include Global.h

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec spring
