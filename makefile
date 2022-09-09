
DEVICE=GD32F30X_HD

SRCS=$(wildcard app/src/*.c)
LIBS=$(wildcard lib/src/*.c)

INCULDE_DIR = app/inc lib/inc

SRC_OBJS=$(patsubst app/%.c, app/%.o, $(SRCS))
LIB_OBJS=$(patsubst lib/src/%.c, lib/%.o, $(LIBS))

CFLAGS=-mthumb -mcpu=cortex-m4 -mfloat-abi=softfp -fno-builtin -fno-strict-aliasing -fdata-sections -fms-extensions -ffunction-sections -O1 -ggdb $(foreach dir,$(INCULDE_DIR),-I$(dir)) -D$(DEVICE)
LDFLAGS=-mthumb -mcpu=cortex-m4 -mfloat-abi=softfp -Wl,--gc-sections -flto -specs=nano.specs -T lib/gd32.ld -ggdb

CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
OC=arm-none-eabi-objcopy

all: clean driver app

app: $(SRC_OBJS)
	$(LD) $(LDFLAGS) $^ -lc -lm lib/driver.a -o output.elf
	$(OC) -O binary output.elf output.bin

driver: $(LIB_OBJS)
	$(AR) rcs lib/driver.a $^

clean:
	@rm -rf lib\*.o *.elf *.hex *.bin lib\*.a app\src\*.o

flash:
	@openocd -f cmsis-dap.cfg -f openocd_target.cfg  -c init -c halt -c "program output.bin 0x8000000" -c reset -c shutdown

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

lib/%.o: lib/src/%.c
	$(CC) $(CFLAGS) -c $< -o $@
