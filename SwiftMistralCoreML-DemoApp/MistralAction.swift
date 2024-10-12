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
    
    func execute(parameters: MistralParameters, onTokenGenerated: @escaping (String) -> Void, completion: @escaping () -> Void) async {
        do {
            // Initialize the tokenizer parser and BPE encoder.
            let tokenizerParser = try TokenizerParser()
            let bpeEncoder = BPEEncoder(tokenizerParser: tokenizerParser)
            
            // Update system prompt if provided.
            updateSystemPromptIfNeeded(using: parameters)
            
            // Add the user's input to the messages.
            messages.append(Message(role: .user, content: parameters.userInput))
            
            // Prepare the input for the Mistral model.
            let mistralInput = try MistralInput(messages: messages, bpeEncoder: bpeEncoder, tokenizer: tokenizerParser)
    
            // Create a text generator with the model and encoders.
            let textGenerator = try TextGenerator(bpeEncoder: bpeEncoder, tokenizerParser: tokenizerParser)
            
            let generatedText = try await textGenerator.generateText(from: mistralInput.inputTokens, using: parameters, progressHandler: { generatedWord in
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
}
