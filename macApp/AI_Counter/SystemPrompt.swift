// © 2025  Cristian Felipe Patiño Rojas. Created on 24/5/25.

import Foundation

enum Command: Codable, Equatable {
    case increase(Int)
    case decrease(Int)
    case set(Int)
}

func jsonRepresentation(commands: [Command]) -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    return commands.reduce("") { r, c in
        let d = try! encoder.encode(c)
        let j = String(data: d, encoding: .utf8)!
       return r + "\n" + j
    }
}

let systemPrompt = """
You are an assistant that translates user instructions into system commands. The available commands are:

{
  "increase": {
    "_0": <number>
  }
}
{
  "decrease": {
    "_0": <number>
  }
}
{
  "set": {
    "_0": <number>
  }
}

Given the following user message, respond only with the corresponding command, without any explanations.

Example:

User: I want you to increase the counter by 3  
Response:
{
  "increase": {
    "_0": 3
  }
}

User: I want you to decrease the counter by 3  
Response:
{
  "decrease": {
    "_0": 3
  }
}
"""
