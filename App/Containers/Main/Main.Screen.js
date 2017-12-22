import React, {Component} from 'react'
import {Dimensions, ScrollView, Text, Image, View, StyleSheet} from 'react-native'
import {Container, Header, Left, Body, Right, Button, Icon, Title, Content} from 'native-base'

import MainStyles from './Main.Styles'

export default class MainScreen extends Component {

  render() {
    return (
      <Container>
        <Header>
          <Body>
          <Title>MainScreen</Title>
          </Body>
        </Header>
        <Content>

          <View style={MainStyles.container}>
            <View style={MainStyles.center}>
              <Text>This is main</Text>
            </View>
          </View>

        </Content>
      </Container>
    )
  }
}
