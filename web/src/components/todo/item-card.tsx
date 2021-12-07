import { CheckCircleIcon } from '@heroicons/react/outline'
import clsx from 'clsx'
import React, { useState } from 'react'
import toast from 'react-hot-toast'

interface TodoItemCardProps {
	item: TodoItem
	editable: boolean
	notifyItemUpdate?: (item: TodoItem) => void
}

type State = {
	item: TodoItem
	loading: false
}

export const TodoItemCard = ({ item, editable }: TodoItemCardProps) => {
	const [state, setState] = useState<State>({
		item,
		loading: false
	})

	const toggleTodoItemStatus = () => {
		if (!editable) {
			return window.alert('You cannot edit item in archive todo list!')
		}

		if (state.item.completed && !window.confirm('Are you sure you want to incomplete?')) {
			return
		}

		const payload = {
			item_id: state.item.id,
			completed: !state.item.completed
		}

		const requestOptions = {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(payload)
		} as RequestInit

		const toastId = toast.loading(
			`Marking item ${payload.completed ? 'completed' : 'incomplete'}...`
		)

		fetch('/api/list/item/completed', requestOptions)
			.then(res => res.json())
			.then(
				(res: ServerResponse) => {
					console.log(res)

					if (res.code === 200) {
						toast.dismiss(toastId)
						setState(prevState => ({ ...prevState, item: res.data as TodoItem }))
					} else {
						toast.dismiss(toastId)
						toast.error(res.error)
					}
				},
				error => {
					console.log(error)
					toast.error('Something went wrong.')
					toast.dismiss(toastId)
				}
			)
	}

	return (
		<div className="px-2 py-1 rounded-md bg-gray-100">
			<div className="flex flex-row justify-between items-center">
				<p>{state.item.content}</p>
				<div className="">
					<CheckCircleIcon
						onClick={toggleTodoItemStatus}
						className={clsx(
							'w-8 h-8 cursor-pointer cursor-pointer',
							state.item.completed ? 'text-green-500' : 'text-gray-500',
							{
								'pointer-events-none': !editable
							}
						)}
					/>
				</div>
			</div>
		</div>
	)
}
