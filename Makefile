TARGET = :clang:7.1
ARCHS = armv7s arm64

include theos/makefiles/common.mk

THEOS_BUILD_DIR = debs

TWEAK_NAME = SwitchSpring
SwitchSpring_FILES = Tweak.x HBSSRespringAlertItem.x
SwitchSpring_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	./inject.sh
