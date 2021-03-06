import ResponsiveWindow from '../../../components/react/responsive_window'
import React from 'react'
import SubmissionFlow from '../components/submission_flow'
import ThankYou from '../components/thank_you'
import UploadPhotoLanding from '../components/upload_photo_landing'
import geo from '../../../components/geo/index.coffee'
import reducers from './reducers'
import createHistory from 'history/createBrowserHistory'
import createLogger from 'redux-logger'
import thunkMiddleware from 'redux-thunk'
import { Provider } from 'react-redux'
import { Router, Route } from 'react-router'
import { createStore, applyMiddleware } from 'redux'
import { updateAuthFormStateAndClearError } from './actions'
import { render } from 'react-dom'
import { routerMiddleware } from 'react-router-redux'

function setupSubmissionFlow () {
  // load google maps for autocomplete
  geo.loadGoogleMaps()

  const loggerMiddleware = createLogger()
  const history = createHistory()
  const store = createStore(
    reducers,
    applyMiddleware(
      thunkMiddleware, // lets us dispatch() functions
      routerMiddleware(history),
      loggerMiddleware // middleware that logs actions
    )
  )

  render(
    <Provider store={store}>
      <ResponsiveWindow>
        <Router history={history}>
          <div>
            <Route exact path='/consign2/submission' component={SubmissionFlow} />
            <Route path='/consign2/submission/:submission_id/thank_you' component={ThankYou} />
            <Route
              path='/consign2/submission/:submission_id/upload'
              render={() => {
                store.dispatch(updateAuthFormStateAndClearError('logIn'))
                return (<UploadPhotoLanding />)
              }}
            />
          </div>
        </Router>
      </ResponsiveWindow>
    </Provider>,
    document.getElementById('consignments2-submission__flow')
  )
}

export default () => {
  setupSubmissionFlow()
}
