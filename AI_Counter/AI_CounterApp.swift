// © 2025  Cristian Felipe Patiño Rojas. Created on 24/5/25.

import SwiftUI

@main
struct AI_CounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

import SwiftUI

struct UserInput: View {
    @State var state = ""
    @Binding var command: Command?
    @Binding var error: String?
    let isLoading: Bool
    let handle: (String) -> Void
    var body: some View {
        TextField("Enter command", text: $state)
            .frame(width: 300)
            .overlay(progressView, alignment: .trailing)
            .onSubmit {
                handle(state)
            }
    }
    
    var progressView: some View {
        ProgressView().scaleEffect(0.4).opacity(isLoading ? 1 : 0)
    }
}
struct ContentView: View {
    @State var count = 0
    @State var userInput = ""
    @State var command: Command?
    @State var error: String?
    @State var isLoading = false
    var body: some View {
        VStack {
           Counter(state: $count)
            UserInput(
                command: $command,
                error: $error, isLoading: isLoading,  handle: handle
            )
           Text(error ?? "")
                .foregroundColor(.red)
                .opacity(error != nil ? 1 : 0)
        }
        .padding()
    }
    
    func handle(_ input: String) {
        isLoading = true
    
        Task {
            do {
                command = try await Client.ollama.mapToCommand(userInput: input)
                isLoading = false
                
                switch command {
                case let .increase(n): count += n
                case let .decrease(n): count -= n
                case let .set(n): count = n
                case .none: break
                }
             
            } catch {
                self.error = error.localizedDescription
                isLoading = false
                self.error = nil
            }
        }
    }
    
}

struct Counter: View {
    @Binding var state: Int
    var body: some View {
        HStack {
            Button("-") { state += 1 }
            Text(state.description)
            Button("+") { state -= 1 }
        }
    }
}

#Preview {
    ContentView()
}

