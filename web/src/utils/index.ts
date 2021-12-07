import axios, { CancelTokenSource } from 'axios'
import { DateTime } from 'luxon'


const makeRequestCreator = () => {
	let cancelTokenSource: CancelTokenSource

	return (query: string) => {
		if (cancelTokenSource) {
			cancelTokenSource.cancel()
		}

		cancelTokenSource = axios.CancelToken.source()

		try {
			const res = axios(query, { cancelToken: cancelTokenSource.token })
			return res
		} catch (error) {
			if (axios.isCancel(error)) {
				console.log('Request canceled', error)
			} else {
				console.log('Something went wrong: ', error)
			}
		}
	}
}

export const liveSearch = makeRequestCreator()

export const compareDate = (d1: string, d2: string, order?: 'asc' | 'desc') => {
	if (order === 'asc') return DateTime.fromISO(d1) < DateTime.fromISO(d2) ? 0 : -1

	return DateTime.fromISO(d2) < DateTime.fromISO(d1) ? 0 : -1
}
