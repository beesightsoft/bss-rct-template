import AppNavigation from '../Navigation/AppNavigation'

const getCurrentRouteName = (state) => {
  const route = state.routes[state.index]
  return typeof route.index === 'undefined' ? route.routeName : getCurrentRouteName(route)
}

export const reducer = (state, action) => {
  const nextState = AppNavigation.router.getStateForAction(action, state)
  // prevents navigating twice to the same route
  if (state && nextState) {
    const stateRouteName = getCurrentRouteName(state)
    const nextStateRouteName = getCurrentRouteName(nextState)
    return stateRouteName === nextStateRouteName ? state : nextState
  }
  // Simply return the original `state` if `nextState` is null or undefined.
  return nextState || state
}
