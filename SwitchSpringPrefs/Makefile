TARGET =: clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = SwitchSpringPrefs
SwitchSpringPrefs_FILES = HBSSRootListController.x $(wildcard *.m)
SwitchSpringPrefs_INSTALL_PATH = /Library/PreferenceBundles
SwitchSpringPrefs_FRAMEWORKS = UIKit CoreGraphics QuartzCore
SwitchSpringPrefs_PRIVATE_FRAMEWORKS = Preferences
SwitchSpringPrefs_LIBRARIES = hbangprefs
SwitchSpringPrefs_CFLAGS = -Qunused-arguments

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SwitchSpringPrefs.plist$(ECHO_END)
