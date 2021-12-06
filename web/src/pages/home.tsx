import { SwitchButton } from 'components/button/switch'
import { Spinner } from 'components/spinner'
import { TodoListCard } from 'components/todo/list-card'
import React, { useEffect, useState } from 'react'
import AppLayout from '../components/layout'

type State = {
	todos: {
		[id: string]: TodoList
	}
	loading: boolean
	showArchived: boolean
	error?: string
}

export function Home() {
	const [state, setState] = useState<State>({
		todos: {},
		showArchived: false,
		loading: false
	})

	useEffect(() => {
		const reqOptions = {
			method: 'GET',
			mode: 'no-cors'
		} as RequestInit

		setState(prevState => ({ ...prevState, loading: true }))

		fetch('/api/lists', reqOptions)
			.then(res => res.json())
			.then((res: ServerResponse) => {
				console.log(res)
				const todos = res.data as Todos

				const mappedTodos = todos.reduce((agg, todo) => ({ ...agg, [todo.id]: todo }), {})

				setState(prevState => ({ ...prevState, todos: mappedTodos, loading: true }))
			})
			.finally(() => {
				setState(prevState => ({ ...prevState, loading: false }))
			})
	}, [])

	return (
		<AppLayout>
			<div className="w-full my-5 flex flex-row items-center justify-between">
				<SwitchButton
					title={'Show Archived'}
					state={state.showArchived}
					callback={() =>
						setState(prevState => ({ ...prevState, showArchived: !state.showArchived }))
					}
				/>
				<button className="bg-green-400 focus-within:outline-none hover:bg-green-500 px-4 py-2 rounded-md text-white">
					Add New
				</button>
			</div>
			{state.loading ? (
				<div className="flex flex-col items-center justify-center space-y-2">
					<Spinner className="w-10 h-10" />
					<p className="text-gray-500 animate-pulse">Loading Todos...</p>
				</div>
			) : Object.keys(state.todos).length === 0 ? (
				<div className="text-center">
					<p className="font-bold text-lg">No Todo Found</p>
				</div>
			) : (
				<div className="w-full space-y-2 mb-10">
							{Object.values(state.todos)
						.filter(todo => state.showArchived === todo.archived)
						.map(todo => (
							<TodoListCard
								key={todo.id}
								todo={todo}
								notifyListUpdate={todo =>
									setState(prevState => ({
										...prevState,
										todos: { ...prevState.todos, [todo.id]: todo }
									}))
								}
							/>
						))}
				</div>
			)}
		</AppLayout>
	)
}

export default Home
