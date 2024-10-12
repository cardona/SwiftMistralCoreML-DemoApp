//
//  MistralAction.swift
//  SwiftMistralCoreML-DemoApp
//
//  Created by Oscar Cardona on 11/10/24.
//


import Foundation
import CoreML
import NaturalLanguage
import SwiftMistralCoreML


final class MistralAction {
    /// An array of messages used in the conversation with the model.
    private var messages: [Message] = []
    private let textGenerator: TextGenerator
    
    init() throws {
        do {
            self.textGenerator = try TextGenerator()
        } catch {
            throw ActionError.textGenerationFailed
        }
        
    }
    
 
    func execute(parameters: MistralParameters, onTokenGenerated: @escaping (String) -> Void, completion: @escaping () -> Void) async {
        do {
            
            // Update system prompt if provided.
            updateSystemPromptIfNeeded(using: parameters)
            
            // Add the user's input to the messages.
            messages.append(Message(role: .user, content: parameters.userInput))
            
            
            let generatedText = try await textGenerator.generateText(messages: messages, using: parameters, progressHandler: { generatedWord in
                // Clean and send the generated word to the UI.
                onTokenGenerated(generatedWord.cleanGeneratedText())
            })
            self.messages.append(Message(role: .assistant, content: generatedText))
            completion()
        } catch {
            handleError(error)
        }
    }
    
    /// Updates the system prompt in the messages if needed.
    private func updateSystemPromptIfNeeded(using parameters: MistralParameters) {
        guard !parameters.systemPrompt.isEmpty else { return }
        
        // Remove the existing system prompt if present.
        if let firstMessage = messages.first, firstMessage.role == .system {
            messages.removeFirst()
        }
        // Insert the new system prompt at the beginning.
        messages.insert(Message(role: .system, content: parameters.systemPrompt), at: 0)
    }
    
    /// Handles errors by logging or displaying them appropriately.
    private func handleError(_ error: Error) {
        // Implement appropriate error handling here.
        print("Error: \(error.localizedDescription)")
    }
    
    enum ActionError: Error {
        case textGenerationFailed
    }
}
