import React, { Component } from 'react'
import { ScrollView, Text, Image, View } from 'react-native'
import { Images } from '../../Themes/index'
import SplashScreen from 'react-native-splash-screen'

// Styles
import styles from './Launch.Styles'

export default class LaunchScreen extends Component {
  render() {
    return (
      <View style={styles.mainContainer}>
        <ScrollView style={styles.container}>
          <View style={styles.centered}>
            <Image source={Images.launch} style={styles.logo} />
          </View>

          <View style={styles.section} >
            <Image source={Images.ready} />
            <Text style={styles.sectionText}>
              HI, I LOVE YOU ^.^
            </Text>
          </View>

        </ScrollView>
      </View>
    )
  }

  componentDidMount() {
    SplashScreen.hide();

    setTimeout(() => {
      this.props.navigation.navigate('MainScreen', {})
    }, 2000)
  }

}
