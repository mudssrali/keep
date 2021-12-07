import React from 'react'
import ReactDOM from 'react-dom'
import { Toaster } from 'react-hot-toast'
import Routes from './routing'
import './styles/app.css'
import './styles/helper.css'

ReactDOM.render(
	<>
		<Toaster
			position={'top-right'}
			toastOptions={{
				style: {
					margin: '15px',
					background: '#363636',
					color: '#fff',
					width: '340px'
				},
				className: 'text-base',
				duration: 3000
			}}
		/>
		<Routes />
	</>,
	document.getElementById('keep')
)
