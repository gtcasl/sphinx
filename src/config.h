#ifndef __OPTIONS__
#define __OPTIONS__

#include "literals.h"
#include <htl/cache.h>
// #define ICACHE_ENABLE
// #define ICACHE_BITS 15
// #define ILINE_BITS 10

using namespace ch::htl::cache;


#define DCACHE_ENABLE

#define D_CacheSize 1024
#define D_BlockSize 4
#define D_NumWays 1


using Cfg = Config<D_CacheSize, D_BlockSize, D_NumWays, 32, 32, 8>;

#define JAL_EXE
#define FORWARDING

#endif

