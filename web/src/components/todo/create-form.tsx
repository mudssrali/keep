import clsx from 'clsx'
import { Spinner } from 'components/spinner'
import React, { useState } from 'react'
import toast from 'react-hot-toast'

interface TodoCreateFormProps {
	type: 'LIST' | 'ITEM'
	todoId?: string
	notifyCreate: (todo: TodoList | TodoItem) => void
}

type State = {
	submitted: boolean
	todo: string
}

export const TodoCreateForm = ({ type, notifyCreate, todoId }: TodoCreateFormProps) => {
	const [state, setState] = useState<State>({
		submitted: false,
		todo: ''
	})

	const handleFormSubmission = (event: React.FormEvent<HTMLFormElement>) => {
		event.preventDefault()

		const createUrl = type === 'LIST' ? '/api/list/create' : '/api/list/create/item'
		const payload =
			type === 'LIST'
				? {
					title: state.todo
				}
				: {
					list_id: todoId,
					content: state.todo
				}

		const requestOptions = {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(payload)
		} as RequestInit

		setState(prevState => ({ ...prevState, submitted: true }))

		fetch(createUrl, requestOptions)
			.then(res => res.json())
			.then(
				(res: ServerResponse) => {
					console.log(res)
					if (res.code === 200) {
						notifyCreate(res.data as TodoList | TodoItem)
					} else {
						setState(prevState => ({ ...prevState, submitted: false }))
						toast.error('Something went wrong!')
					}
				},
				error => {
					console.log(error)
				}
			)
	}

	return (
		<form className="p-4 flex flex-col space-y-4" onSubmit={handleFormSubmission}>
			<p className="font-semibold">What&apos;s on your mind?</p>
			<textarea
				className={clsx('border border-gray-200 focus-within:outline-none p-2 rounded-md', {
					'pointer-events-none': state.submitted
				})}
				required={true}
				placeholder={'Jot something down...'}
				disabled={state.submitted}
				rows={4}
				onChange={event =>
					setState(prevState => ({ ...prevState, todo: event.target.value }))
				}
			/>
			<button
				className={clsx(
					'inline-flex items-center bg-blue-400 focus-within:outline-none hover:bg-blue-500 px-4 py-2 rounded-md text-white',
					{
						'pointer-events-none': state.submitted || !state.todo.trim()
					}
				)}
				disabled={state.submitted || !state.todo.trim()}>
				{state.submitted ? (
					<>
						<Spinner className="w-4 h-4" />
						<span className="mx-auto">Saving...</span>
					</>
				) : (
					<span className="mx-auto">Save</span>
				)}
			</button>
		</form>
	)
}
