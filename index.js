global.NTron = (__DEV__ && console.tron) ? console.tron.log : () => {};
global.NLog = (__DEV__) ? console.log : () => {};
global.NLoge = (__DEV__) ? console.error : () => {};

import './App/Config/ReactotronConfig'
import { AppRegistry } from 'react-native'
import App from './App/Containers/App'

AppRegistry.registerComponent('BeeSightSoftRCT', () => App)
