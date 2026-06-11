export TARGET_LDFLAGS = -Wl,-ld_classic
export ADDITIONAL_CFLAGS = -F$(SYSROOT)/System/Library/PrivateFrameworks
export ADDITIONAL_LDFLAGS = -F$(SYSROOT)/System/Library/PrivateFrameworks

DEBUG = 0
FINALPACKAGE = 1
PACKAGE_VERSION = 0.0.4

TARGET := iphone:clang:14.5:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SurgeCCDirect SurgeCCRule SurgeCCProxy SurgePrefs

SurgeCCDirect_BUNDLE_EXTENSION = bundle
SurgeCCDirect_FILES = SurgeCCDirect.m
SurgeCCDirect_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCDirect_FRAMEWORKS = Foundation UIKit
SurgeCCDirect_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCDirect_CFLAGS = -fobjc-arc
SurgeCCDirect_RESOURCE_DIRS = ResourcesDirect

SurgeCCRule_BUNDLE_EXTENSION = bundle
SurgeCCRule_FILES = SurgeCCRule.m
SurgeCCRule_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCRule_FRAMEWORKS = Foundation UIKit
SurgeCCRule_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCRule_CFLAGS = -fobjc-arc
SurgeCCRule_RESOURCE_DIRS = ResourcesRule

SurgeCCProxy_BUNDLE_EXTENSION = bundle
SurgeCCProxy_FILES = SurgeCCProxy.m
SurgeCCProxy_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCProxy_FRAMEWORKS = Foundation UIKit
SurgeCCProxy_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCProxy_CFLAGS = -fobjc-arc
SurgeCCProxy_RESOURCE_DIRS = ResourcesProxy

SurgePrefs_BUNDLE_EXTENSION = bundle
SurgePrefs_FILES = SurgePrefsRootListController.m
SurgePrefs_INSTALL_PATH = /Library/PreferenceBundles
SurgePrefs_FRAMEWORKS = Foundation UIKit
SurgePrefs_PRIVATE_FRAMEWORKS = Preferences
SurgePrefs_CFLAGS = -fobjc-arc
SurgePrefs_RESOURCE_DIRS = ResourcesPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

after-stage::
	find $(THEOS_STAGING_DIR) -type f -name "surgectl" -exec chmod 755 {} +
