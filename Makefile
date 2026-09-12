#-------------------------------------------------------------------------------
.SUFFIXES:
#-------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment.")
endif

TOPDIR ?= $(CURDIR)

WUMS_ROOT := $(DEVKITPRO)/wums

#-------------------------------------------------------------------------------
# Application metadata
#-------------------------------------------------------------------------------

APP_NAME       := Aroma Launcher
APP_SHORTNAME  := Aroma Launcher
APP_AUTHOR     := PretenZeo

# Aroma Launcher does not bundle a /vol/content directory.
# Hard-clear APP_CONTENT BEFORE wut_rules is parsed so no stale shell,
# command-line, or recursive-make value can make wuhbtool package one.
override APP_CONTENT :=
unexport APP_CONTENT

include $(DEVKITPRO)/wut/share/wut_rules

# Belt-and-suspenders protection: even if a future environment somehow
# injects a content option, remove it from the final wuhbtool arguments.
WUHB_OPTIONS := $(filter-out --content=%,$(WUHB_OPTIONS))

#-------------------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------------------

TARGET      := homebrew_launcher
BUILD       := build
SOURCES     := source
DATA        := data
INCLUDES    := include

CONTENT     :=
ICON        := meta/icon.png
TV_SPLASH   := meta/tv-splash.png
DRC_SPLASH  := meta/drc-splash.png

#-------------------------------------------------------------------------------
# Compiler settings
#-------------------------------------------------------------------------------

CFLAGS := -g -Wall -O2 -ffunction-sections \
          $(MACHDEP)

CFLAGS += $(INCLUDE) -D__WIIU__ -D__WUT__

CXXFLAGS := $(CFLAGS)

ASFLAGS := -g $(ARCH)

LDFLAGS = -g $(ARCH) $(RPXSPECS) -Wl,-Map,$(notdir $*.map)

LIBS := -lrpxloader -lwuhbutils -lSDL2_mixer -lSDL2 -lmodplug -lmpg123 -lvorbisfile -lvorbis -logg -lm -lwut

LIBDIRS := $(PORTLIBS) $(WUT_ROOT) $(WUMS_ROOT)

#-------------------------------------------------------------------------------
# Usually no need to edit below here
#-------------------------------------------------------------------------------

ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT := $(CURDIR)/$(TARGET)
export TOPDIR := $(CURDIR)

export VPATH := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
                $(foreach dir,$(DATA),$(CURDIR)/$(dir))

export DEPSDIR := $(CURDIR)/$(BUILD)

CFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES := $(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

ifeq ($(strip $(CPPFILES)),)
export LD := $(CC)
else
export LD := $(CXX)
endif

export OFILES_BIN := $(addsuffix .o,$(BINFILES))
export OFILES_SRC := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
export OFILES := $(OFILES_BIN) $(OFILES_SRC)

export HFILES_BIN := $(addsuffix .h,$(subst .,_,$(BINFILES)))

export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                  $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                  -I$(CURDIR)/$(BUILD)

export LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

# CONTENT bundling is intentionally disabled for Aroma Launcher.
override APP_CONTENT :=
unexport APP_CONTENT

ifneq (,$(strip $(ICON)))
export APP_ICON := $(TOPDIR)/$(ICON)
else ifneq (,$(wildcard $(TOPDIR)/$(TARGET).png))
export APP_ICON := $(TOPDIR)/$(TARGET).png
else ifneq (,$(wildcard $(TOPDIR)/icon.png))
export APP_ICON := $(TOPDIR)/icon.png
endif

ifneq (,$(strip $(TV_SPLASH)))
export APP_TV_SPLASH := $(TOPDIR)/$(TV_SPLASH)
else ifneq (,$(wildcard $(TOPDIR)/tv-splash.png))
export APP_TV_SPLASH := $(TOPDIR)/tv-splash.png
else ifneq (,$(wildcard $(TOPDIR)/splash.png))
export APP_TV_SPLASH := $(TOPDIR)/splash.png
endif

ifneq (,$(strip $(DRC_SPLASH)))
export APP_DRC_SPLASH := $(TOPDIR)/$(DRC_SPLASH)
else ifneq (,$(wildcard $(TOPDIR)/drc-splash.png))
export APP_DRC_SPLASH := $(TOPDIR)/drc-splash.png
else ifneq (,$(wildcard $(TOPDIR)/splash.png))
export APP_DRC_SPLASH := $(TOPDIR)/splash.png
endif

.PHONY: $(BUILD) clean all

all: $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).wuhb $(TARGET).rpx $(TARGET).elf

else

.PHONY: all

DEPENDS := $(OFILES:.o=.d)

all: $(OUTPUT).wuhb

$(OUTPUT).wuhb: $(OUTPUT).rpx
$(OUTPUT).rpx: $(OUTPUT).elf
$(OUTPUT).elf: $(OFILES)

$(OFILES_SRC): $(HFILES_BIN)

%.bin.o %_bin.h: %.bin
	@echo $(notdir $<)
	@$(bin2o)

-include $(DEPENDS)

endif