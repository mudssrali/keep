import { ArchiveIcon } from '@heroicons/react/solid'
import clsx from 'clsx'
import { Modal } from 'components/modal'
import { useComponentVisible } from 'hooks/useComponentVisible'
import React, { useState } from 'react'
import { toast } from 'react-hot-toast'
import { compareDate } from 'utils'
import { TodoCreateForm } from './create-form'
import { TodoItemCard } from './item-card'

interface TodoListCardProps {
	todo: TodoList
	notifyListUpdate: (list: TodoList) => void
}

type State = {
	list: TodoList
	action?: ListActions
}

const enum ListActions {
	TOGGLE_STATUS,
	EDIT
}

export const TodoListCard = ({ todo, notifyListUpdate }: TodoListCardProps) => {
	const [state, setState] = useState<State>({
		list: todo
	})

	const {
		ref: modalRef,
		isComponentVisible: modalIsVisible,
		setIsComponentVisible: setModalIsVisble
	} = useComponentVisible(false)

	const toggleTodoListStatus = () => {
		if (
			state.list.archived &&
			!window.confirm('Are you sure you want to unarchive this todo?')
		) {
			return
		}

		const payload = {
			list_id: state.list.id,
			archived: !state.list.archived
		}

		const requestOptions = {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(payload)
		} as RequestInit

		const toastId = toast.loading(
			`Marking list ${payload.archived ? 'archived' : 'unarchive'}...`
		)

		fetch('/api/list/archived', requestOptions)
			.then(res => res.json())
			.then(
				(res: ServerResponse) => {
					console.log(res)

					if (res.code === 200) {
						toast.dismiss(toastId)
						notifyListUpdate(res.data as TodoList)
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
		<div className="p-2 rounded-md border border-gray-400">
			<div
				className={clsx(
					'flex flex-row items-center justify-between p-2 rounded-md',
					state.list.archived ? 'bg-gray-500' : 'bg-green-500'
				)}>
				<p className="font-semibold text-white">{state.list.title}</p>
				<div className="bg-white w-10 rounded-full h-10 flex items-center flex-row justify-center group">
					<ArchiveIcon
						onClick={toggleTodoListStatus}
						className={clsx(
							'w-8 h-8 cursor-pointer',
							state.list.archived
								? 'text-gray-500 hover:text-gray-700'
								: 'text-green-500 group-hover:text-green-700'
						)}
					/>
				</div>
			</div>

			<div className="mt-4 space-y-2">
				{(state.list.items ?? [])
					.sort((a, b) => compareDate(a.inserted_at, b.inserted_at, 'asc'))
					.map(item => (
						<TodoItemCard key={item.id} item={item} editable={!state.list.archived} />
					))}
			</div>
			<div className="mt-2">
				<button
					onClick={() => setModalIsVisble(!modalIsVisible)}
					className="bg-blue-400 focus-within:outline-none hover:bg-blue-500 px-4 py-2 rounded-md text-white">
					New Item
				</button>
			</div>
			{modalIsVisible && (
				<Modal>
					<div className="w-full border-gray-400 rounded-md bg-white" ref={modalRef}>
						<TodoCreateForm
							type={'ITEM'}
							list={state.list}
							notifyCreate={item => {
								setModalIsVisble(!modalIsVisible)
								setState(prevState => ({
									...prevState,
									list: {
										...prevState.list,
										items: [...prevState.list.items, item as TodoItem]
									}
								}))
							}}
						/>
					</div>
				</Modal>
			)}
		</div>
	)
}
