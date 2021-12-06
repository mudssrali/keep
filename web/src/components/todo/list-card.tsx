import { ArchiveIcon } from '@heroicons/react/solid'
import clsx from 'clsx'
import React, { useState } from 'react'
import { TodoItemCard } from './item-card'

interface TodoListCardProps {
	todo: TodoList
	notifyListUpdate?: (list: TodoList) => void
}

type State = {
	list: TodoList
	loading: boolean
	action?: ListActions
}

const enum ListActions {
	ARCHIVED,
	UNARCHIVED,
	EDIT
}

export const TodoListCard = ({ todo }: TodoListCardProps) => {
	const [state, setState] = useState<State>({
		list: todo,
		loading: false
	})

	return (
		<div className="p-2 rounded-md border border-gray-400">
			<div
				className={clsx(
					'flex flex-row items-center justify-between p-2 rounded-md',
					state.list.archived ? 'bg-gray-500' : 'bg-blue-500'
				)}>
				<p className="font-semibold text-white">{todo.title}</p>
				<div className="bg-white w-10 rounded-full h-10 flex items-center flex-row justify-center group">
					<ArchiveIcon
						className={clsx(
							'w-8 h-8 cursor-pointer',
							state.list.archived
								? 'text-gray-500 hover:text-gray-700'
								: 'text-blue-500 group-hover:text-blue-700'
						)}
					/>
				</div>
			</div>

			<div className="mt-4 space-y-2">
				{(state.list.items ?? []).map(item => (
					<TodoItemCard key={item.id} item={item} />
				))}
			</div>
		</div>
	)
}
