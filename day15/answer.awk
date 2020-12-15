BEGIN { FS = "," }

{
	for (i = 1; i <= NF; i++) {
		turns[i] = $i
		count[$i] = 1
		last_turn[$i] = i
		#print turns[i], count[turns[i]], last_turn[turns[i-1]]
	}
}

END {
	for (i = NF + 1; i <= 2020; i++) {
		turns[i] = turns[i-1] in count && count[turns[i-1]] == 1 ? 0 : i - 1 - last_turn[turns[i-1]]
		count[turns[i]] += 1
		last_turn[turns[i-1]] = i - 1
		#print turns[i], count[turns[i]], last_turn[turns[i-1]]
	}
	print turns[2020]
	for (i = 2021; i <= 30000000; i++) {
		turns[i] = turns[i-1] in count && count[turns[i-1]] == 1 ? 0 : i - 1 - last_turn[turns[i-1]]
		count[turns[i]] += 1
		last_turn[turns[i-1]] = i - 1
		#print turns[i], count[turns[i]], last_turn[turns[i-1]]
	}
	print turns[30000000]
}
