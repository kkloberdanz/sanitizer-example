/*
 * (C) 2022 Kyle Kloberdanz
 *
 * This program reads bytes from stdin and converts the bytes into double
 * precision floats, interpreting the bytes as little endian.
 *
 * You can use thins on UNIX (e.g. MacOS)/Linux platforms as follows:
 * $ cat /dev/urandom | ./stdin-div.exe
 */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

union dbl_mem {
    uint64_t u;
    double d;
};

/*
 * returns a negative number on error, 0 on success
 */
static int read_double(FILE *fp, double *dbl /* out */) {
    union dbl_mem mem;
    char buf[sizeof(double)];
    int err = 0;

    mem.u = 0;

    if ((fread(buf, 1, sizeof(double), fp) < sizeof(double))) {
        fprintf(stderr, "read error occured\n");
        err = -1;
        goto done;
    }
    
    for (size_t i = 0; i < sizeof(double); i++) {
        uint64_t n = buf[i];
        mem.u |= (n << (i * 8));
    }

    *dbl = mem.d;
done:
    return err;
}

int main(void) {
    double d;
    int err = 0;

    do {
        err = read_double(stdin, &d);
        if (err) {
            exit(EXIT_FAILURE);
        }
        printf("%f\n", d);
    } while (err == 0);
    return err;
}
