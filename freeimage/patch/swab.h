#ifndef __SWAB_H__
#define __SWAB_H__
/* system has no swab.  emulate via bswap */ 
// mettre ça dans un fichier a part swap.c et include dans les sources de librawlite
#include <byteswap.h>
static void swab(const void *from, void *to, ssize_t n) {
  const int16_t *in = (int16_t*)from;
  int16_t *out = (int16_t*)to;
  int i;
  n /= 2;
  for (i = 0 ; i < n; i++) {
    out[i] = bswap_16(in[i]);
  }
}
#endif //__SWAB_H__