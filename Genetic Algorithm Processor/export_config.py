


def start(f):
	f.write("#ifndef __OPTIONS__\n")
	f.write("#define __OPTIONS__\n")


def end(f):
	f.write("#endif\n")


def write_config(f, config):
	for opt, val in config.items():
		f.write("#define {} {}\n".format(opt, val))

def export(config):
	f = open("../src/config.h", "w")

	start(f)
	write_config(f, config)
	end(f)



