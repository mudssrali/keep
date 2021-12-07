import { ArchiveIcon } from '@heroicons/react/solid'
import clsx from 'clsx'
import React, { useState } from 'react'
import { toast } from 'react-hot-toast'
import { TodoItemCard } from './item-card'

interface TodoListCardProps {
	todo: TodoList
	notifyListUpdate: (list: TodoList) => void
}

type State = {
	action?: ListActions
}

const enum ListActions {
	TOGGLE_STATUS,
	EDIT
}

export const TodoListCard = ({ todo, notifyListUpdate }: TodoListCardProps) => {
	const [state, setState] = useState<State>({})

	const toggleTodoListStatus = () => {
		if (todo.archived && !window.confirm('Are you sure you want to unarchive this todo')) {
			return
		}

		const payload = {
			list_id: todo.id,
			archived: !todo.archived
		}

		const requestOptions = {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(payload)
		} as RequestInit

		const toastId = toast.loading('archiving list...')

		fetch('/api/list/archived', requestOptions)
			.then(res => res.json())
			.then((res: ServerResponse) => {
				console.log(res)

				if (res.code === 200) {
					toast.dismiss(toastId)
					notifyListUpdate(res.data as TodoList)
				} else {
					toast.dismiss(toastId)
					toast.error('Something went wrong!')
				}
			})
			.finally(() => {
				toast.dismiss(toastId)
			})
	}

	return (
		<div className="p-2 rounded-md border border-gray-400">
			<div
				className={clsx(
					'flex flex-row items-center justify-between p-2 rounded-md',
					todo.archived ? 'bg-gray-500' : 'bg-blue-500'
				)}>
				<p className="font-semibold text-white">{todo.title}</p>
				<div className="bg-white w-10 rounded-full h-10 flex items-center flex-row justify-center group">
					<ArchiveIcon
						onClick={toggleTodoListStatus}
						className={clsx(
							'w-8 h-8 cursor-pointer',
							todo.archived
								? 'text-gray-500 hover:text-gray-700'
								: 'text-blue-500 group-hover:text-blue-700'
						)}
					/>
				</div>
			</div>

			<div className="mt-4 space-y-2">
				{(todo.items ?? []).map(item => (
					<TodoItemCard key={item.id} item={item} />
				))}
			</div>
		</div>
	)
}
