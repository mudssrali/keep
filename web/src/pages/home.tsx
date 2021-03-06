import { SwitchButton } from 'components/button/switch'
import { Modal } from 'components/modal'
import { Spinner } from 'components/spinner'
import { TodoCreateForm } from 'components/todo/create-form'
import { TodoListCard } from 'components/todo/list-card'
import { useComponentVisible } from 'hooks/useComponentVisible'
import React, { useEffect, useState } from 'react'
import { compareDate } from 'utils'
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

	const {
		ref: modalRef,
		isComponentVisible: modalIsVisible,
		setIsComponentVisible: setModalIsVisble
	} = useComponentVisible(false)

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
				<button
					onClick={() => setModalIsVisble(!modalIsVisible)}
					className="bg-blue-400 focus-within:outline-none hover:bg-blue-500 px-4 py-2 rounded-md text-white">
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
								.sort((a, b) => compareDate(a.inserted_at, b.inserted_at, 'asc'))
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

			{modalIsVisible && (
				<Modal>
					<div className="w-full border-gray-400 rounded-md bg-white" ref={modalRef}>
						<TodoCreateForm
							type={'LIST'}
							notifyCreate={todo => {
								setModalIsVisble(!modalIsVisible)
								setState(prevState => ({
									...prevState,
									todos: { ...prevState.todos, [todo.id]: todo as TodoList }
								}))
							}}
						/>
					</div>
				</Modal>
			)}
		</AppLayout>
	)
}

export default Home
