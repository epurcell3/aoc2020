{
	pcount++
	program[pcount]["instr"] = $1
	program[pcount]["arg1"] = $2
}

function exec_instr() {
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
