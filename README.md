# SwiftMistralCoreML Demo App

This demo application demonstrates how to use the [SwiftMistralCoreML](https://github.com/cardona/SwiftMistralCoreML) library to generate conversational AI responses using the Mistral-Interact7B model with CoreML. The app is now adapted for both **macOS** and **iOS**, and supports the **INT4** and **FP16** model variants.

---

## Key Information

- **macOS Compatibility**: Requires macOS 15 or later.
- **iOS Compatibility**: Requires iOS 18 or later and an **iPhone 15 Pro** or newer.  
- **Simulator Limitation**: The app does not work on the iOS simulator because it lacks direct GPU access.

---

## Features

- **Support for macOS and iOS**: Runs on macOS (15+) and iOS (18+ on iPhone 15 Pro and newer).
- **Model Variants**: Supports **INT4** and **FP16** models.
- **Interactive Chat**: Send inputs to the model and receive real-time responses.
- **Customizable Parameters**: Adjust the system prompt, decoding algorithm, and max tokens.
- **SwiftUI Interface**: Clean and modern user interface built with SwiftUI.
- **Light and Dark Mode**: Easily switch themes.
- **Decoding Strategies**: Supports both **Greedy** and **Top-K** sampling.

---

## Prerequisites

1. **Download the Model**:  
   - Download the **INT4** or **FP16** Mistral-Interact7B model from [Hugging Face](https://huggingface.co/apple/mistral-coreml).
   - The model file will have the `.mlmodel` extension.

2. **Add the Model to the Project**:  
   - Place the `.mlmodel` file(s) in the same directory as the project.
   - Drag and drop the file(s) into your Xcode project.

---

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/cardona/SwiftMistralCoreML-DemoApp.git
   ```
2. Open the project in Xcode.
3. Ensure that the downloaded `.mlmodel` file(s) are added to the project.
4. Run the app on a compatible **macOS** or **iOS** device (not in the simulator).

---

## Usage

1. **System Prompt**:  
   Define the assistant’s behavior in the **System Prompt** field.  
   Example:  
   ```
   You are a helpful, concise, and accurate assistant.
   ```

2. **User Input**:  
   Enter your question or command in the input area.

3. **Select Decoding Algorithm**:  
   - **Greedy**: Always picks the token with the highest probability.
   - **Top-K**: Samples from the top K tokens, introducing variability.

4. **Adjust Max Tokens**:  
   Use the slider to set the maximum number of tokens to generate.

---

## Important Notes

- **First-Time Execution**: The first time you run the model, initialization might take longer as the model is optimized for the device.
- **iOS Limitations**:  
   - Requires iOS 18 or later and an **iPhone 15 Pro** (or newer).  
   - **Not supported in the iOS simulator** due to GPU access restrictions.

---

## Testing Request

If you own an **iPhone 16 Pro** (or newer) running **iOS 18** or later, we kindly ask you to test the application and let us know if it works correctly. Since we do not have access to the latest hardware, your feedback would be greatly appreciated.

---

## Known Limitations

- The first model execution may take longer due to initialization.
- The app will not run on the iOS simulator.

---

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request in the [GitHub repository](https://github.com/cardona/SwiftMistralCoreML-DemoApp).

---

## License

This project is licensed under the **MIT License**.

---

*This demo app showcases the capabilities of [SwiftMistralCoreML](https://github.com/cardona/SwiftMistralCoreML) and provides an interactive way to experience conversational AI on macOS and iOS.*  