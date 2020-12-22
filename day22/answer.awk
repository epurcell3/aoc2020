BEGIN {
	RS = "\n\n"
	FS = ":"
}

{
	split($2, cards, /\n/)
	tos[NR] = 1
	bos[NR] = 0
	for (i in cards) {
		if (cards[i]) {
			decks[NR][++bos[NR]] = cards[i]
			orig_decks[NR][bos[NR]] = cards[i]
		}
	}
	total_cards += bos[NR]
}

END {
	do {
		#print_deck(1)
		#print_deck(2)
		my_card = pop_card(1)
		crab_card = pop_card(2)
		#print ++turn ":", my_card " vs " crab_card
		if (my_card > crab_card) {
			append_card(1, my_card)
			append_card(1, crab_card)
		} else {
			append_card(2, crab_card)
			append_card(2, my_card)
		}
	} while (length(decks[1]) != total_cards && length(decks[2]) != total_cards)
	winning_player = length(decks[1]) == total_cards ? 1 : 2
	print "Player " winning_player " wins! " score(decks[winning_player], tos[winning_player], bos[winning_player])

	delete decks[1]
	delete decks[2]
	tos[1] = 1
	tos[2] = 1
	bos[1] = length(orig_decks[1])
	bos[2] = length(orig_decks[2])
	for (i = 1; i <= length(orig_decks[1]); i++) {
		decks[1][i] = orig_decks[1][i]
		decks[2][i] = orig_decks[2][i]
	}
	p2_winner = recursion_combat(1, 2)
	print "Player " p2_winner " wins! " score(decks[p2_winner], tos[p2_winner], bos[p2_winner])
}

function pop_card(player,      value) {
	value = decks[player][tos[player]]
	delete decks[player][tos[player]]
	tos[player]++
	return value
}

function append_card(player, value) {
	decks[player][++bos[player]] = value
}

function copy_deck(player, start_ind, n_cards,		i) {
	delete tos[player + 2]
	delete bos[player + 2]
	delete decks[player + 2]
	tos[player + 2] = 1
	for (i = start_ind; i < start_ind + n_cards; i++) decks[player + 2][++bos[player + 2]] = decks[player][i]
}

function score(deck, start_ind, end_ind,		i, multiplier, n) {
	multiplier = length(deck)
	for (i = start_ind; i <= end_ind; i++) {
		n += multiplier * deck[i]
		multiplier--
	}
	return n
}

function serialize_state(p1, p2,		str, i) {
	str = "P" p1 ":"
	for (i = tos[p1]; i <= bos[p1]; i++) str = str decks[p1][i] ","
	str = str "P" p2 ":"
	for (i = tos[p2]; i <= bos[p2]; i++) str = str decks[p2][i] ","
	return str
}

function recursion_combat(p1, p2,		loop_prevented, my_card, crab_card, winner) {
	delete turn[p1]
	delete prev_states[p1]
	loop_prevented = 0
	do {
		#print serialize_state(p1, p2)
		if (p1 in prev_states && serialize_state(p1, p2) in prev_states[p1]) {
			loop_prevented = 1
			break
		} else {
			prev_states[p1][serialize_state(p1, p2)] = 1
		}
		#print ""
		#print_deck(p1)
		#print_deck(p2)
		my_card = pop_card(p1)
		crab_card = pop_card(p2)
		#print ++turn[p1] ":", "(p" p1 ") " my_card " vs (p" p2 ") " crab_card
		if (length(decks[p1]) < my_card || length(decks[p2]) < crab_card) {
			if (my_card > crab_card) {
				append_card(p1, my_card)
				append_card(p1, crab_card)
			} else {
				append_card(p2, crab_card)
				append_card(p2, my_card)
			}
		} else {
			# recurse....
			copy_deck(p1, tos[p1], my_card)
			copy_deck(p2, tos[p2], crab_card)
			if (recursion_combat(p1 + 2, p2 + 2) % 2 == 1) {
				append_card(p1, my_card)
				append_card(p1, crab_card)
			} else {
				append_card(p2, crab_card)
				append_card(p2, my_card)
			}
		}
	} while (length(decks[p1]) != 0 && length(decks[p2]) != 0)
	return loop_prevented || length(decks[p2]) == 0 ? p1 : p2
}

function print_deck(player,		i) {
	printf "Player %d: ", player
	for (i in decks[player]) {
		#printf "%d (%d), ", decks[player][i], i
		printf "%d, ", decks[player][i]
	}
	print ""
}
