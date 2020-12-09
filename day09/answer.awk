BEGIN {
	lpreamble = 25
}

NR > lpreamble {
	part1_found = 0
	for (i in valid_sums) {
		for (j in valid_sums) {
			if (valid_sums[i][j] == $0) {
				part1_found = 1
				break;
			}
		}
		if (part1_found) break;
	}
	if (!part1_found) {
		invalid_number = $0
		print $0
	}
	delete valid_sums[window[NR - lpreamble]]
	delete window[NR - lpreamble]
}

{
	all_nums[NR] = $0
	for (i in window) {
		valid_sums[$0][window[i]] = $0 + window[i]
	}
	window[NR] = $0
	#debug()
}

END {
	for (start in all_nums) {
		tmp_sum = 0
		i = start
		while (tmp_sum < invalid_number) {
			tmp_sum += all_nums[i]
			i++
		}
		if (tmp_sum == invalid_number) {
			print min_range(all_nums, start, i) + max_range(all_nums, start, i)
			break
		}
	}
}

function min_range(arr, start, end, min, i) {
	min = 9999999999999999999
	for (i = start; i < end; i++) {
		if (arr[i] < min) min = arr[i]
	}
	return min
}

function max_range(arr, start, end, max, i) {
	max = -9999999999999999999
	for (i = start; i < end; i++) {
		if (arr[i] > max) max = arr[i]
	}
	return max
}


function debug() {
	for (i in window) {
		print i, window[i]
	}
	for (i in valid_sums) {
		for (j in valid_sums[i]) {
			printf "%d + %d = %d\n", i, j, valid_sums[i][j]
		}
	}
	print "---"
}
