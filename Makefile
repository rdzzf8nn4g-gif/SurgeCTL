THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
DEBUG = 0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SurgeCCDirect SurgeCCRule SurgeCCProxy

# 1. 直连模块 (Direct)
SurgeCCDirect_BUNDLE_EXTENSION = bundle
SurgeCCDirect_FILES = SurgeCCDirect.m
SurgeCCDirect_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCDirect_FRAMEWORKS = UIKit
SurgeCCDirect_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCDirect_CFLAGS = -fobjc-arc
SurgeCCDirect_RESOURCE_DIRS = ResourcesDirect

# 2. 规则模块 (Rule)
SurgeCCRule_BUNDLE_EXTENSION = bundle
SurgeCCRule_FILES = SurgeCCRule.m
SurgeCCRule_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCRule_FRAMEWORKS = UIKit
SurgeCCRule_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCRule_CFLAGS = -fobjc-arc
SurgeCCRule_RESOURCE_DIRS = ResourcesRule

# 3. 全局模块 (Proxy)
SurgeCCProxy_BUNDLE_EXTENSION = bundle
SurgeCCProxy_FILES = SurgeCCProxy.m
SurgeCCProxy_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCProxy_FRAMEWORKS = UIKit
SurgeCCProxy_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCProxy_CFLAGS = -fobjc-arc
SurgeCCProxy_RESOURCE_DIRS = ResourcesProxy

include $(THEOS_MAKE_PATH)/bundle.mk

# 赋予 CLI 脚本执行权限
after-stage::
	chmod 755 $(THEOS_STAGING_DIR)/var/jb/usr/bin/surgectl
