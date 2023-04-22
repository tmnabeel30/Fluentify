//
//  ContentView.swift
//  Fluentify
//
//  Created by Nabeel on 22/04/23.
//


import SwiftUI
struct ChatView: View {
    @State private var message = ""
    @State private var messages = ["AI: Hello! How can I assist you today?"]
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    if message.contains("user") {
                        HStack {
                            Spacer()
                            Text(message)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(ChatBubble(isFromCurrentUser: true))
                        }
                    } else if message.contains("AI"){
                        HStack {
                            Text(message)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .clipShape(ChatBubble(isFromCurrentUser: false))
                            Spacer()
                        }
                    }
                }
            }
            HStack {
                TextField("Type a message...", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .clipShape(Capsule())
                    .onTapGesture {
                        addKeyboardObserver()
                    }
                Button("Send") {
                    messages.append("user: " + message)
                    message = ""
                    removeKeyboardObserver()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Circle())
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .offset(y: -keyboardHeight)
            .animation(.easeInOut(duration: 0.3))
        }
        .edgesIgnoringSafeArea(.bottom)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            keyboardHeight = keyboardFrame.height
        }
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct ChatBubble: Shape {
    var isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isFromCurrentUser ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ChatView()
        }
    }
}
