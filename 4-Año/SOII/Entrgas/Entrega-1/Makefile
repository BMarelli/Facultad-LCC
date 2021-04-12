TARGET = garden
CFLAGS = -g

.PHONY: all clean

all: $(TARGET)

clean:
	$(RM) $(TARGET)

$(TARGET): garden.c guindows.c
	$(CC) $(CFLAGS) -o $@ $^
