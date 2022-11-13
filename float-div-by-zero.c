/*
 * (C) 2022 Kyle Kloberdanz
 *
 * To make program halt on error:
 *
 * Kyles-MacBook-Air% UBSAN_OPTIONS="halt_on_error=1" ./float-div-by-zero.exe
 * float-div-by-zero.c:10:26: runtime error: division by zero
 * SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior float-div-by-zero.c:10:26 in
 * zsh: abort      UBSAN_OPTIONS="halt_on_error=1" ./float-div-by-zero.exe
 */
#include <stdio.h>

int main(void) {
    double x = 0.0;
    double y = 3.3;
    printf("%f\n", y / x);
    return 0;
}
