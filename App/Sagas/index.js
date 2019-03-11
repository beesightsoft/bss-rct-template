import { all, takeLatest } from 'redux-saga/effects'
import { StartupTypes } from '../Redux/StartupRedux'
import { startup } from './StartupSagas'

/* ------------ REDUX ------------ */
//@nhancv 2019-03-11
//TODO: Add REDUX here: Action, Function, Service

/* ------------- Connect Types To Sagas ------------- */

export default function * root () {
  yield all([
    // some sagas only receive an action
    takeLatest(StartupTypes.STARTUP, startup),

    //@nhancv 2019-03-11
    //TODO: redux flow configuration

  ])
}
