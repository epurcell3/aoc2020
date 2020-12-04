BEGIN {
	RS = "\n\n"
	count = 0
}

{
	parse_fields($0)
	if ("byr" in fields &&
	    "iyr" in fields &&
	    "eyr" in fields &&
	    "hgt" in fields &&
	    "hcl" in fields &&
	    "ecl" in fields &&
	    "pid" in fields) {
		    count++
	}
	if ("byr" in fields && match(fields["byr"], /^[[:digit:]]{4}$/) == 1 && 
	    	fields["byr"] >= 1920 && fields["byr"] <= 2002 &&
	    "iyr" in fields && match(fields["iyr"], /^[[:digit:]]{4}$/) == 1 && 
	    	fields["iyr"] >= 2010 && fields["iyr"] <= 2020 &&
	    "eyr" in fields && match(fields["eyr"], /^[[:digit:]]{4}$/) == 1 && 
	    	fields["eyr"] >= 2020 && fields["eyr"] <= 2030 &&
	    "hgt" in fields && (match(fields["hgt"], /^([[:digit:]]+)(cm|in)/, height) &&
	    	((height[2] == "cm" && height[1] >= 150 && height[1] <= 193) ||
		(height[2] == "in" && height[1] >= 59 && height[1] <= 76))) &&
	    "hcl" in fields && match(fields["hcl"], /^#[0-9a-f]{6}$/) == 1 &&
	    "ecl" in fields && match(fields["ecl"], /(amb|blu|brn|gry|grn|hzl|oth)/) == 1 &&
	    "pid" in fields && match(fields["pid"], /^[[:digit:]]{9}$/)) {
		    part2_count++
	}
	delete fields
}

END {
	printf "%d\n", count
	printf "%d\n", part2_count
}

function parse_fields(record) {
	split(record, data)
	for (i in data) {
		split(data[i], parts, ":")
		fields[parts[1]] = parts[2]
	}
}
