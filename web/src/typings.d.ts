type Todos = TodoList[]

interface TodoList {
	id: string
	title: string
	archived: boolean
	inserted_at: string
	updated_at: string
	items: TodoItem[]
}

interface TodoItem {
	id: string
	list_id: string
	content: string
	completed: boolean
	inserted_at: string
	updated_at: string
}

interface ServerResponse {
	status: 'success' | 'failed'
	code: number
	data: unknown
	error: string
}
