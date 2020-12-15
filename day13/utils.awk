function max_by_value(arr, _n) {
	_n = 1
	for (i in arr) {
		if (arr[i] > arr[_n]) {
			_n = i
		}
	}
}
