{
	numbers[$0] = 1
}

END {
	for (n in numbers) {
		if ((2020 - n) in numbers) {
			printf "%d * %d = %d\n", n, 2020 - n, n * (2020 - n)
			break
		}
	}

	for (n1 in numbers) {
		found = 0
		for (n2 in numbers) {
			if ((2020 - n1 - n2) in numbers) {
				printf "%d * %d * %d = %d\n", n1, n2, (2020 - n1 - n2), n1 * n2 * (2020 - n1 - n2)
				found = 1
				break;
			}
		}
		if (found == 1) { break }
	}
}
