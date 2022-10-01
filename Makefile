TARGET=d2h

AS=nasm
ASFLAGS=-f macho64

LD=ld
LDFLAGS=-macosx_version_min 12.6.0 -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem

.PHONY: clean

all: $(TARGET)

dec2hex.o: dec2hex.asm
	$(AS) -o dec2hex.o dec2hex.asm $(ASFLAGS)

$(TARGET): dec2hex.o
	$(LD) -o $(TARGET) dec2hex.o $(LDFLAGS)

install: $(TARGET)
	install ./d2h /usr/local/bin

clean:
	rm dec2hex.o $(TARGET) 2> /dev/null || true

