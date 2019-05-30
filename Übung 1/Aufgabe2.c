#include <stdio.h>
int main() {
    int sum = 0;
    int i;

    for(i = 0; i < 100; i++) {
        if (i % 3 == 0 || i % 5 == 0) {
            sum += i;
        }
    }
    // sum enthaelt das Ergebnis
    printf("Sum: %d\n", sum);
    return 0;
}
