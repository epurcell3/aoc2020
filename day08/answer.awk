END {
	pid = 1
	acc = 0
	#Part 1
	while (!(pid in run_instr)) {
		run_instr[pid]++
		exec_instr()
	}
	print acc

	#Part 2
	for (i in program) {
		if (program[i]["instr"] == "jmp") {
			orig_instr = "jmp"
			program[i]["instr"] = "nop"
		} else if (program[i]["instr"] == "nop") {
			orig_instr = "nop"
			program[i]["instr"] = "jmp"
		} else {
			continue
		}
		#print_program()
		pid = 1
		acc = 0
		broke_early = 0
		delete run_instr
		while (pid in program) {
			#debug()
			if (run_instr[pid] > 1) {
				program[i]["instr"] = orig_instr
				broke_early = 1
				break;
			}
			run_instr[pid]++
			switch (program[pid]["instr"]) {
			case "acc":
				acc += program[pid]["arg1"]
			case "nop":
				pid++
				break;
			case "jmp":
				pid += program[pid]["arg1"]
				break;
			}
		}
		if (!broke_early) {
			print acc
			break
		}
	}
}

function print_program(i) {
	for (i in program) {
		printf "%d: %s %s\n", i, program[i]["instr"], program[i]["arg1"]
	}
	print ""
}

function debug() {
	printf "%d\t%d: %s %s\n", pid, run_instr[pid], program[pid]["instr"], program[pid]["arg1"]
}
