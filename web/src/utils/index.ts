import axios, { CancelTokenSource } from 'axios'

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
