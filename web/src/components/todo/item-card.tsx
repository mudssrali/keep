import { CheckCircleIcon } from '@heroicons/react/outline'
import clsx from 'clsx'
import React, { useState } from 'react'

interface TodoItemCardProps {
	item: TodoItem
	notifyItemUpdate?: (item: TodoItem) => void
}

type State = {
	item: TodoItem
	loading: false
}

const enum ItemActions {
	MARK_COMPLETED,
	MARK_INCOMPLETED,
	EDIT
}

export const TodoItemCard = ({ item }: TodoItemCardProps) => {
	const [state, setState] = useState<State>({
		item,
		loading: false
	})

	return (
		<div className="px-2 py-1 rounded-md bg-gray-100">
			<div className="flex flex-row justify-between items-center">
				<p>{state.item.content}</p>
				<div className="">
					<CheckCircleIcon
						className={clsx('w-8 h-8', {
							'text-green-500': item.completed,
							'text-gray-500': !item.completed
						})}
					/>
				</div>
			</div>
		</div>
	)
}
