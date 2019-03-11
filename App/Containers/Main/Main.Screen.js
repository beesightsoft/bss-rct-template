import React, { Component } from 'react'
import { Text, View } from 'react-native'
import { Body, Container, Content, Header, Title } from 'native-base'

import MainStyles from './Main.Styles'
import Config from 'react-native-config'

export default class MainScreen extends Component {

  render () {
    return (
      <Container>
        <Header>
          <Body>
          <Title>{Config.ROOT_URL}</Title>
          </Body>
        </Header>
        <Content>

          <View style={MainStyles.container}>
            <View style={MainStyles.center}>
              <Text style={{
                fontFamily: 'Roboto-Light'
              }}>This is main</Text>
            </View>
          </View>

        </Content>
      </Container>
    )
  }
}
