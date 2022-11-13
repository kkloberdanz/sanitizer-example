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
OBJS = $(patsubst %.c,%.o,$(SRC))

.PHONY: sanitize
sanitize: OPT=-O0 -ggdb3 -fsanitize=float-divide-by-zero
sanitize: all

.PHONY: all
all: divide-by-zero

divide-by-zero: $(OBJS)
	$(CC) -o divide-by-zero $(OBJS) $(CFLAGS) $(LDFLAGS)

%.o: %.c $(HEADERS)
	$(CC) -c $< -o $@ $(CFLAGS)

.PHONY: lint
lint:
	clang-tidy *.c *.h

.PHONY: fmt
fmt:
	clang-format -i *.c *.h

.PHONY: clean
clean:
	rm -f divide-by-zero
	rm -f *.o
