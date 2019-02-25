import React, { Component } from 'react'
import { NavigationActions, StackActions } from 'react-navigation'
import { ScrollView, Text, Image, View } from 'react-native'
import { Images } from '../../Themes/index'

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
    setTimeout(() => {
      this.props.navigation.dispatch(StackActions.reset({
          index: 0,
          actions: [
            NavigationActions.navigate({routeName: 'MainScreen'})
          ],
        }));
    }, 2000)
  }

}
