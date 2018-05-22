import React, { Component } from 'react'
import { Dimensions, ScrollView, Text, Image, View, StyleSheet } from 'react-native'
import { Container, Header, Left, Body, Right, Button, Icon, Title, Content } from 'native-base'

import MainStyles from './Main.Styles'
import Config from 'react-native-config'
export default class MainScreen extends Component {

  render() {
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
                fontFamily: "Roboto-Light"
                }}>This is main</Text>
            </View>
          </View>

        </Content>
      </Container>
    )
  }
}
