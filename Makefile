# ================= 修复 GitHub Actions (Xcode 15+) 编译问题 =================
# 1. 强制使用经典链接器，修复 "multiply defined is obsolete" 警告
export TARGET_LDFLAGS = -Wl,-ld_classic
# 2. 显式指定私有框架搜索路径，防止 "framework not found"
export ADDITIONAL_CFLAGS = -F$(SYSROOT)/System/Library/PrivateFrameworks
export ADDITIONAL_LDFLAGS = -F$(SYSROOT)/System/Library/PrivateFrameworks

# ================= 生产环境与版本配置 =================
DEBUG = 0
FINALPACKAGE = 1
PACKAGE_VERSION = 0.0.3

# ================= 编译目标与架构 =================
# 必须显式指定为 14.5 或 16.5，强制使用 Theos 下载的完整版 SDK
TARGET := iphone:clang:14.5:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SurgeCCDirect SurgeCCRule SurgeCCProxy

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

include $(THEOS_MAKE_PATH)/bundle.mk

# ================= 打包后处理脚本 =================
# 自动寻找并赋予 surgectl 命令行脚本执行权限
after-stage::
	find $(THEOS_STAGING_DIR) -type f -name "surgectl" -exec chmod 755 {} +
