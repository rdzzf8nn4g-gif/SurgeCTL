# ================= 修复 GitHub Actions 编译问题 =================
export TARGET_LDFLAGS = -Wl,-ld_classic
export ADDITIONAL_CFLAGS = -F$(SYSROOT)/System/Library/PrivateFrameworks
export ADDITIONAL_LDFLAGS = -F$(SYSROOT)/System/Library/PrivateFrameworks

# ================= 生产环境与版本配置 =================
DEBUG = 0
FINALPACKAGE = 1
PACKAGE_VERSION = 0.0.4

# ================= 编译目标与架构 =================
TARGET := iphone:clang:14.5:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

# ================= 声明要同时编译的 4 个组件 =================
BUNDLE_NAME = SurgeCCDirect SurgeCCRule SurgeCCProxy SurgePrefs

# ----------------- 1. 直连模块 (Direct) -----------------
SurgeCCDirect_BUNDLE_EXTENSION = bundle
SurgeCCDirect_FILES = SurgeCCDirect.m
SurgeCCDirect_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCDirect_FRAMEWORKS = Foundation UIKit
SurgeCCDirect_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCDirect_CFLAGS = -fobjc-arc
SurgeCCDirect_RESOURCE_DIRS = ResourcesDirect

# ----------------- 2. 规则模块 (Rule) -----------------
SurgeCCRule_BUNDLE_EXTENSION = bundle
SurgeCCRule_FILES = SurgeCCRule.m
SurgeCCRule_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCRule_FRAMEWORKS = Foundation UIKit
SurgeCCRule_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCRule_CFLAGS = -fobjc-arc
SurgeCCRule_RESOURCE_DIRS = ResourcesRule

# ----------------- 3. 全局模块 (Proxy) -----------------
SurgeCCProxy_BUNDLE_EXTENSION = bundle
SurgeCCProxy_FILES = SurgeCCProxy.m
SurgeCCProxy_INSTALL_PATH = /Library/ControlCenter/Bundles
SurgeCCProxy_FRAMEWORKS = Foundation UIKit
SurgeCCProxy_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SurgeCCProxy_CFLAGS = -fobjc-arc
SurgeCCProxy_RESOURCE_DIRS = ResourcesProxy

# ----------------- 4. 新增：系统设置面板模块 (Preferences) -----------------
SurgePrefs_BUNDLE_EXTENSION = bundle
SurgePrefs_FILES = SurgePrefsRootListController.m
SurgePrefs_INSTALL_PATH = /Library/PreferenceBundles
SurgePrefs_FRAMEWORKS = Foundation UIKit
SurgePrefs_PRIVATE_FRAMEWORKS = Preferences
SurgePrefs_CFLAGS = -fobjc-arc
SurgePrefs_RESOURCE_DIRS = ResourcesPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

# ================= 打包后处理脚本 =================
after-stage::
	find $(THEOS_STAGING_DIR) -type f -name "surgectl" -exec chmod 755 {} +
