//
//  ContentView.swift
//  SwiftMistralCoreML-DemoApp
//
//  Created by Oscar Cardona on 11/10/24.
//

import SwiftUI
import SwiftMistralCoreML

enum Theme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
}

struct ContentView: View {
    @State private var userInput: String = "How many taxis are there in New York?"
    @State private var displayedText: String = ""
    @State private var systemPrompt: String = "You are a helpful, concise, and accurate assistant. Answer questions clearly and directly."
    @State private var selectedAlgorithm: DecodingAlgorithm = .greedy
    @State private var maxTokens: Double = 100
    @State private var topKValue: Int = 10
    @State private var selectedTheme: Theme = .light
    @State private var isGenerating: Bool = false
    @State private var selectedModelType: MistralType = .int4
    @State private var tokensPerSecond: Double = 0.0
    @State private var timeSinceFirstToken: Double = 0.0
    @State private var firstTokenTime: Double? = nil
    @State private var totalTokens: Int = 0
    
    private let mistral = try? MistralAction()
    
    private var colors: ThemeColors {
        ThemeColors.colors(for: selectedTheme)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            modelOutputSection()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 10)
            
            HStack(alignment: .top) {
                VStack(spacing: 20) {
                    systemPromptSection()
                    userInputSection()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                controlsSection()
                    .frame(width: 300)
                    .padding(.leading, 20)
            }
            .padding(.horizontal, 20)
        }
        .background(colors.background)
        .preferredColorScheme(selectedTheme == .dark ? .dark : .light)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func modelOutputSection() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Model Output:")
                    .font(.headline)
                    .foregroundColor(colors.text)
                
                Spacer()
                
                Button(action: copyToClipboard) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(colors.text)
                        .padding(.trailing, 10)
                }
                .buttonStyle(PlainButtonStyle())
                .help("Copy to clipboard")
                
                Button(action: clearOutput) {
                    Image(systemName: "trash")
                        .foregroundColor(colors.text)
                        .padding(.trailing, 10)
                }
                .buttonStyle(PlainButtonStyle())
                .help("Clear output")
            }
            
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(displayedText.split(separator: "\n"), id: \ .self) { line in
                            if line.hasPrefix("User:") {
                                Text(line)
                                    .foregroundColor(.blue)
                                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .padding(.bottom, 2)
                            } else if line.hasPrefix("Assistant:") {
                                Text(line)
                                    .foregroundColor(colors.text)
                                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .padding(.bottom, 2)
                            } else {
                                Text(line)
                                    .foregroundColor(colors.text)
                                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .padding(.bottom, 2)
                            }
                        }
                        Text("").id("bottom")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
                }
                .background(colors.background)
                .border(colors.border, width: 1)
                .onChange(of: displayedText) {
                    scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func systemPromptSection() -> some View {
        VStack(alignment: .leading) {
            Text("System Prompt:")
                .font(.headline)
                .foregroundColor(colors.text)
            TextEditor(text: $systemPrompt)
                .frame(height: 56)
                .border(colors.border, width: 1)
                .background(colors.background)
                .foregroundColor(colors.text)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
        }
    }
    
    @ViewBuilder
    private func userInputSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Input:")
                .font(.headline)
                .foregroundColor(colors.text)
            TextEditor(text: $userInput)
                .border(colors.border, width: 1)
                .background(colors.background)
                .foregroundColor(colors.text)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .frame(height: selectedAlgorithm == .topK ? 160 : 100)
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private func controlsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            themePicker()
            modelTypePicker()
            decodingAlgorithmPicker()
            
            if selectedAlgorithm == .topK {
                topKSlider()
            }
            
            maxTokensSlider()
            tokenStatistics()
            sendButton()
        }
    }
    
    @ViewBuilder
    private func themePicker() -> some View {
        VStack(alignment: .leading) {
            Picker("Theme", selection: $selectedTheme) {
                ForEach(Theme.allCases, id: \ .self) { theme in
                    Text(theme.rawValue)
                        .tag(theme)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    @ViewBuilder
    private func modelTypePicker() -> some View {
        VStack(alignment: .leading) {
            Text("Model Type:")
                .font(.headline)
                .foregroundColor(colors.text)
            Picker("Mistral7B-Instruct", selection: $selectedModelType) {
                Text("Int4").tag(MistralType.int4)
                Text("Float16").tag(MistralType.fp16)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(colors.background)
            .foregroundColor(colors.text)
        }
    }
    
    @ViewBuilder
    private func decodingAlgorithmPicker() -> some View {
        VStack(alignment: .leading) {
            Text("Decoding Algorithm:")
                .font(.headline)
                .foregroundColor(colors.text)
            Picker("Algorithm", selection: $selectedAlgorithm) {
                ForEach(DecodingAlgorithm.allCases, id: \ .self) { algorithm in
                    Text(algorithm.rawValue)
                        .foregroundColor(colors.text)
                        .tag(algorithm)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .background(colors.background)
            .foregroundColor(colors.text)
        }
    }
    
    @ViewBuilder
    private func topKSlider() -> some View {
        VStack(alignment: .leading) {
            Text("Top K Value: \(topKValue)")
                .font(.headline)
                .foregroundColor(colors.text)
            Slider(value: Binding(
                get: { Double(topKValue) },
                set: { topKValue = Int($0) }
            ), in: 1...100, step: 1)
            .accentColor(colors.accent)
        }
    }
    
    @ViewBuilder
    private func maxTokensSlider() -> some View {
        VStack(alignment: .leading) {
            Text("Max Tokens: \(Int(maxTokens))")
                .font(.headline)
                .foregroundColor(colors.text)
            Slider(value: $maxTokens, in: 1...1000, step: 10)
                .accentColor(colors.accent)
        }
    }
    
    @ViewBuilder
    private func tokenStatistics() -> some View {
        VStack(alignment: .leading) {
            Text("Tokens per Second: \(tokensPerSecond, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(colors.text)
            Text("Time Since First Token: \(timeSinceFirstToken, specifier: "%.2f") seconds")
                .font(.headline)
                .foregroundColor(colors.text)
        }
    }
    
    @ViewBuilder
    private func sendButton() -> some View {
        Button(action: {
            Task {
                await generateResponse()
            }
        }) {
            if isGenerating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
            } else {
                Text("Send")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(colors.buttonBackground)
                    .foregroundColor(colors.buttonText)
                    .cornerRadius(10)
            }
        }
        .disabled(isGenerating)
        .padding(.bottom, 20)
    }
    
    @MainActor
    private func generateResponse() async {
        isGenerating = true
        let tokens = Int(maxTokens)
        
        if !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            displayedText += "\nUser: \(userInput)"
        }
        
        let parameters = MistralParameters(
            modelType: selectedModelType,
            userInput: userInput,
            systemPrompt: systemPrompt,
            algorithm: selectedAlgorithm,
            maxTokens: tokens,
            topK: selectedAlgorithm == .topK ? topKValue : nil
        )
        
        displayedText += "\nAssistant: "
        
        let startTime = Date()
        var tokenCount = 0
        var elapsedTimeWithoutFirstToken: TimeInterval = 0
        
        await mistral?.execute(parameters: parameters) { newGeneratedWord in
            DispatchQueue.main.async {
                displayedText += newGeneratedWord
                tokenCount += 1
                if tokenCount == 1 {
                    firstTokenTime = Date().timeIntervalSince(startTime)
                    timeSinceFirstToken = firstTokenTime ?? 0.0
                } else if let firstTokenTime = firstTokenTime {
                    let elapsedTime = Date().timeIntervalSince(startTime) - firstTokenTime
                    elapsedTimeWithoutFirstToken = elapsedTime
                    tokensPerSecond = elapsedTime > 0 ? Double(tokenCount - 1) / elapsedTime : 0.0
                }
            }
        } completion: {
            DispatchQueue.main.async {
                if let firstTokenTime = firstTokenTime, tokenCount > 1 {
                    tokensPerSecond = (Date().timeIntervalSince(startTime) - firstTokenTime) > 0 ? Double(tokenCount - 1) / elapsedTimeWithoutFirstToken : 0.0
                }
                isGenerating = false
            }
        }
    }
    
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(displayedText, forType: .string)
    }
    
    private func clearOutput() {
        displayedText = ""
    }
}


#Preview {
    ContentView()
}
