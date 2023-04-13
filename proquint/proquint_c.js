// a C and JavaScript polyglot \
/* code visible to C

#ifndef __COSMOPOLITAN__
#include <ctype.h>   // isdigit, isxdigit
#include <stdbool.h> // bool
#include <stdio.h>   // printf
#include <stdlib.h>  // calloc, strtoul
#include <string.h>  // strchr
#endif

#define var int
#define let unsigned int
#define readline() getline(&line, &len, stdin)

static int indexof(const char *s, int c) {
  char *f = strchr(s, c);
  if (f != NULL) {
    return f - s;
  } else {
    return -1;
  }
}

static char *joinChars(char a, char b, char c, char d, char e, char f,
                       char g, char h, char i, char j, char k) {
  char * s = calloc(12, sizeof(char));
  s[0] = a; s[1] = b; s[2] = c; s[3] = d; s[4] = e; s[5] = f;
  s[6] = g; s[7] = h; s[8] = i; s[9] = j; s[10] = k;
  return s;
}

static unsigned int parseInt(const char *s, unsigned int base) {
  if (base == 16 && s[0] == '0' && s[1] == 'x') {
    s += 2;
  }
  return strtoul(s, NULL, base);
}

/*/ // code visible to JavaScript

function indexof(s, c) { return s.indexOf(c) }
function isalpha(c) { return /^\w$/.test(c) }
function isdigit(c) { return /^\d$/.test(c) }
function isxdigit(c) { return /^[0-9a-fA-F]$/.test(c) }
function joinChars(...cs) { return cs.join('') }
function printf(_, s) { console.log(s) }

// code visible to C and JavaScript */

const //\
/*
char *///
  vowels = "aiou";
const //\
/*
char *///
  consonants = "bdfghjklmnprstvz";

//\
function isdecimal(s) { /*
static bool isdecimal(const char *s) { // */
  for (let i = 0; s[i]; i++) {
    if (!isdigit(s[i])) {
      return false;
   }
  }
  return true;
}

//\
function ishexadecimal(s) { /*
static bool ishexadecimal(const char *s) { // */
  let i = 0;
  if (s[0] == '0' && s[1] == 'x') {
    i = 2;
  }
  for (let c; (c = s[i]); i++) {
    if (!isxdigit(c)) {
      return false;
    }
  }
  return true;
}

//\
function quint2uint(s) { /*
unsigned int quint2uint(const char *s) { // */
  var i = 0, j = -1, k, c;
  for (k = 0; (c = s[k]); k++) {
    if (!isalpha(c)) {
      continue;
    } else if ((j = indexof(vowels, c)) > -1) {
      i = 4 * i + j;
    } else if ((j = indexof(consonants, c)) > -1) {
      i = 16 * i + j;
    }
  }
  return i;
}

//\
function uint2quint(i) { /*
char *uint2quint(unsigned int i) { // */
  return joinChars(
    consonants[0xf & (i / (1 << 28))], vowels[0x3 & (i / (1 << 26))],
    consonants[0xf & (i / (1 << 22))], vowels[0x3 & (i / (1 << 20))],
    consonants[0xf & (i / (1 << 16))], '-', consonants[0xf & (i / (1 << 12))],
    vowels[0x3 & (i / (1 << 10))], consonants[0xf & (i / (1 << 6))],
    vowels[0x3 & (i / (1 << 4))], consonants[0xf & i]);
}

//\
function convert(s) { /*
void convert(const char *s) { // */
  if (isdecimal(s)) {
    printf("%s\n", uint2quint(parseInt(s, 10)));
  } else if (ishexadecimal(s)) {
    printf("%s\n", uint2quint(parseInt(s, 16)));
  } else {
    printf("%u\n", quint2uint(s));
  }
}

//\
/*
#ifdef PROQUINT_MAIN
void PROQUINT_MAIN(int argc, char *argv[]) {
  char *line;
  size_t len;
  /*/
function main() {
  const argv = scriptArgs;
  const argc = argv.length;
  let line;
  function readline() {
    line = std.in.getline();
    return line.length || -1;
  }
  // */
  if (argc < 2) {
    while (readline() > -1) {
      convert(line);
    }
  } else {
    for (let i = 1; i < argc; i++) {
      convert(argv[i]);
    }
  }
}
//\
main() /*
#endif // */
