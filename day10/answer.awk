{
	adapters[$0] = 0
}

END {
	last_joltage = 0
	for (joltage in adapters) {
		joltage_diff[joltage - last_joltage]++
		last_joltage = joltage
	}
	print joltage_diff[1] * (joltage_diff[3] + 1)

	for (joltage in adapters) {
		adapters[joltage] = paths_to_zero(adapters, joltage)
	}
	last_adapter = max(adapters)
	print adapters[last_adapter]
}

function paths_to_zero(arr, adapter, _paths) {
	if (arr[adapter]) return arr[adapter]
	_paths = 0
	if (adapter == 1 || adapter == 2 || adapter == 3) {
		_paths = 1
	}
	if ((adapter - 1) in arr) _paths += paths_to_zero(arr, adapter - 1)
	if ((adapter - 2) in arr) _paths += paths_to_zero(arr, adapter - 2)
	if ((adapter - 3) in arr) _paths += paths_to_zero(arr, adapter - 3)
	return _paths
}

function max(arr, n) {
	n = 0
	for (i in arr) {
		if (strtonum(i) > n) {
			n = strtonum(i)
		}
	}
	return n
}
