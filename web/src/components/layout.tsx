import React from 'react'
import { Link } from 'react-router-dom'

export const AppLayout: React.FC = ({ children }) => (
	<div className="w-9/12 mx-auto">
		<div className="w-full p-4 border-b-2">
			<Link to="/">
				<h1 className="font-bold text-2xl md:text-4xl text-center">Keep - Simple Notes</h1>
			</Link>
		</div>
		{children}
	</div>
)

export default AppLayout
