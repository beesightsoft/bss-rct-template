import { createAppContainer, createStackNavigator } from 'react-navigation'
import LaunchScreen from '../Containers/Launch/Launch.Screen'
import MainScreen from '../Containers/Main/Main.Screen'

import styles from './Styles/NavigationStyles'

// Manifest of possible screens
const PrimaryNav = createStackNavigator({
  LaunchScreen: { screen: LaunchScreen },
  MainScreen: { screen: MainScreen }
}, {
  // Default config for all screens
  headerMode: 'none',
  initialRouteName: 'LaunchScreen',
  navigationOptions: {
    headerStyle: styles.header,
    gesturesEnabled: false
  }
})

export default createAppContainer(PrimaryNav)
