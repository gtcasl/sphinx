
options = {
	"FORWARDING": {"yes": {"label": "FORWARDING", "val": "", "dependancies": {}}, "no": {"label": "NO_FORWARDING", "val": "", "dependancies": {}}},
	 "BRANCHES":  {"yes": {"label": "BRANCH_WB",  "val": "", "dependancies": {}}, "no": {"label": "BRANCH_MEM",    "val": "", "dependancies": {}}},
	   "JUMPS":   {"yes": {"label": "JAL_MEM",    "val": "", "dependancies": {}}, "no": {"label": "JAL_EXE",       "val": "", "dependancies": {}}},
 "DCACHE": {"yes": {
  						"label": "DCACHE_ENABLE",
 						"val": "",
 						"dependancies": 
 						{
 						    "DLINE_BITS": [5, 10],
 						   "DCACHE_BITS": [11, 20]
 						}
 
  				  },

  			"no": {
  						"label": "DCACHE_DISABLED",
 						"val": "",
 						"dependancies": {},
  				  }},

 "ICACHE": {"yes": {
  						"label": "ICACHE_ENABLE",
 						"val": "",
 						"dependancies": 
 						{
 						    "ILINE_BITS": [5, 10],
 						   "ICACHE_BITS": [11, 20]
 						}
 
  				  },

  			"no": {
  						"label": "ICACHE_DISABLED",
 						"val": "",
 						"dependancies": {},
  				  }},

   }

opposite = {
  
    "#define FORWARDING"      : ["#define NO_FORWARDING"],
    "#define NO_FORWARDING"   : ["#define FORWARDING"],

    "#define BRANCH_WB"       : ["#define BRANCH_MEM"],
    "#define BRANCH_MEM"      : ["#define BRANCH_WB"],

    "#define JAL_MEM"         : ["#define JAL_EXE"],
    "#define JAL_EXE"         : ["#define JAL_MEM"],


    "#define DCACHE_ENABLE"   : ["#define DCACHE_DISABLED"],
    "#define DCACHE_DISABLED" : ["#define DCACHE_ENABLE"],
    "#define DLINE_BITS"      : [5, 10],
    "#define DCACHE_BITS"     : [11, 20],

    "#define ICACHE_ENABLE"   : ["#define ICACHE_DISABLED"],
    "#define ICACHE_DISABLED" : ["#define ICACHE_ENABLE"],
    "#define ILINE_BITS"      : [5, 10],
    "#define ICACHE_BITS"     : [11, 20],

}


