import React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'
import { Home } from '../pages/home'
import { PageNotFound } from '../pages/404'

export function Routes() {
	return (
		<BrowserRouter>
			<Switch>
				<Route path="/" exact component={Home} />
				<Route path="*" component={PageNotFound} />
			</Switch>
		</BrowserRouter>
	)
}

export default Routes
