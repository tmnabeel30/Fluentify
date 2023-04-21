//
//  ContentView.swift
//  Fluentify
//
//  Created by Nabeel on 22/04/23.
//

import SwiftUI

struct ContentView: View {
    
    // Example data for user and bot messages
      let userMessages = ["Hi, how are you?", "Can you help me improve my English?"]
      let botMessages = ["Hello! I'm here to help.", "Of course! Let's get started."]
      
      var body: some View {
          VStack {
              ScrollView {
                  VStack {
                      ForEach(userMessages.indices, id: \.self) { index in
                          HStack {
                              Spacer()
                              Text(userMessages[index])
                                  .padding(10)
                                  .background(Color.blue)
                                  .foregroundColor(Color.white)
                                  .cornerRadius(10)
                                  .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                          }
                      }
                      
                      ForEach(botMessages.indices, id: \.self) { index in
                          HStack {
                              Text(botMessages[index])
                                  .padding(10)
                                  .background(Color.green)
                                  .foregroundColor(Color.white)
                                  .cornerRadius(10)
                                  .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                              Spacer()
                          }
                      }
                  }
              }
              
              // Text input field for user to enter messages
              HStack {
                  TextField("Type your message here...", text: .constant(""))
                      .textFieldStyle(RoundedBorderTextFieldStyle())
                      .padding(.horizontal)
                  Button(action: {
                      // Add user's message to the list of user messages
                  }) {
                      Text("Send")
                  }
                  .padding(.trailing)
              }
              .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
          }
          .navigationTitle("Chat")
      }
  }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
