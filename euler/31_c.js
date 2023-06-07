//\
/* Run with `cc -xc 31_c.js -o 31_c && ./31_c $N`
// or `(deno run|node|qjs) 31_c.js $N`

#include <stdio.h> // printf
#include <stdlib.h> // atoi
#define main() main(int argc, char *const *argv)
#define function int
#define let int
#define print(X) printf("%u\n", X)
int coins[8] = {200, 100, 50, 20, 10, 5, 2, 1};

/*/

const argv = globalThis.process?.argv
  ?? globalThis.Deno?.args
  ?? scriptArgs;
const argc = argv.length;
const coins = [200, 100, 50, 20, 10, 5, 2, 1];
const atoi = (x) => +x;
const print = console.log;

function coinsums(n, j)     /*/
int coinsums(int n, int j) /**/ {
  let result = 0;
  for (let i = j; i < 8; i++) {
    let coin = coins[i];
    if (n > coin) {
      result += coinsums(n - coin, i);
    } else if (n == coin) {
      result++;
    }
  }
  return result;
}

function main() {
  print(coinsums(atoi(argv[argc - 1]), 0));
}

//\
main();
