


def start(f):
	f.write("#ifndef __OPTIONS__\n")
	f.write("#define __OPTIONS__\n")


def end(f):
	f.write("#endif\n")


def write_config(f, config):
	for option in config:
		for conf in option:
			f.write("{}\n".format(conf))

def export(config):
	f = open("../src/config.h", "w")

	start(f)
	write_config(f, config)
	end(f)



