TARGET =: clang
ARCHS = armv7 armv7s arm64
THEOS_BUILD_DIR = debs

include theos/makefiles/common.mk

TWEAK_NAME = SwitchSpring
SwitchSpring_FILES = Tweak.x HBSSRespringAlertItem.x
SwitchSpring_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += SwitchSpringPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-after-install::
	install.exec "killall -9 backboardd"