# ================= 生产环境与版本配置 =================
DEBUG = 0
FINALPACKAGE = 1
PACKAGE_VERSION = 0.0.2

# ================= 编译目标与架构 =================
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
# 安装完成后自动重启 SpringBoard，使控制中心组件立即生效
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

# ================= 声明要同时编译的 3 个组件 =================
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
# 自动寻找并赋予 surgectl 命令行脚本执行权限 (完美兼容 Rootless/Roothide 路径)
after-stage::
	find $(THEOS_STAGING_DIR) -type f -name "surgectl" -exec chmod 755 {} +
