# (C) 2022 Kyle Kloberdanz

CC=cc
OPT=-O2
STD=-std=gnu18
LDFLAGS=-lgmp
WARNING=-Werror -Wall -Wextra -Wpedantic -Wfloat-equal -Wundef -Wshadow \
		-Wpointer-arith -Wcast-align -Wstrict-prototypes -Wmissing-prototypes \
		-Wstrict-overflow=5 -Wwrite-strings -Waggregate-return -Wcast-qual \
		-Wswitch-enum -Wunreachable-code -Wformat -Wformat-security -Wvla

FLAGS=-fstack-protector-all -fPIE -pipe
CFLAGS=$(WARNING) $(STD) $(OPT) $(FLAGS)

SRC = $(wildcard *.c)
HEADERS = $(wildcard *.h)
BINS = $(patsubst %.c,%.exe,$(SRC))

.PHONY: sanitize
sanitize: OPT=-O0 -ggdb3 -fsanitize=float-divide-by-zero,float-cast-overflow,integer-divide-by-zero
sanitize: all

.PHONY: debug
debug: OPT=-O0 -ggdb3
debug: all

.PHONY: all
all: $(BINS)

%.exe: %.c $(HEADERS)
	$(CC) $< -o $@ $(CFLAGS)

.PHONY: lint
lint:
	clang-tidy *.c *.h

.PHONY: fmt
fmt:
	clang-format -i *.c *.h

.PHONY: clean
clean:
	rm -f *.exe
	rm -f *.o
	rm -rf *.dSYM
