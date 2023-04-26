//
//  ContentView.swift
//  Fluentify
//
//  Created by Nabeel on 22/04/23.
//


import SwiftUI
import OpenAI

struct CompletionsQuery: Codable {
    /// ID of the model to use.
    let model: Model
    /// The prompt(s) to generate completions for, encoded as a string, array of strings, array of tokens, or array of token arrays.
    let prompt: String
    /// What sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
    let temperature: Int
    /// The maximum number of tokens to generate in the completion.
    let max_tokens: Int
    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
    let top_p: Int
    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    let frequency_penalty: Int
    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    let presence_penalty: Int
    /// Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
    let stop: [String]
}
struct CompletionsResult: Codable {
    struct Choice: Codable {
        let text: String
        let index: Int
    }

    let id: String
    let object: String
    let created: TimeInterval
    let model: Model
    let choices: [Choice]
}

struct ChatView: View {
    @State private var message = ""
    @State private var messages = ["AI: Hello! How can I assist you today?"]
    @State private var keyboardHeight: CGFloat = 0
    let openai = OpenAI(apiToken: "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")
    
    
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
                    
                    removeKeyboardObserver()
                    openai.completions(query: .init(model: .textDavinci_003, prompt: message, temperature: 0, maxTokens: 100, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])) { result in
                      //Handle response here
                        print(result)
                        
                        message = ""
                    }
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
