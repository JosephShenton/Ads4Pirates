INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Ads4Pirates

$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -F./frameworks
$(TWEAK_NAME)_LDFlags = -L -F./frameworks
$(TWEAK_NAME)_FRAMEWORKS = AdSupport AVFoundation CFNetwork CoreGraphics CoreMedia CoreTelephony MobileCoreServices QuartzCore Security SystemConfiguration WebKit StoreKit
$(TWEAK_NAME)_EMBED_FRAMEWORKS = GoogleMobileAds.framework

include $(THEOS_MAKE_PATH)/tweak.mk
