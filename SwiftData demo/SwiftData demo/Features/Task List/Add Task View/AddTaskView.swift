import SwiftUI

struct AddTaskView: View {
  @Binding var showPopup: Bool
  @Binding var inputText: String
  var onAccept: () -> Void

  var body: some View {
    VStack {
      separator()

      Text("Enter some text")
        .font(.headline)
        .padding(.bottom, 20)

      TextField("Enter text here...", text: $inputText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.horizontal)
        .padding(.bottom, 20)
        .environment(\.colorScheme, .light)
        .background(.white)

      HStack {
        Button("Cancel") {
          withAnimation {
            showPopup = false
          }
        }
        .padding()

        Spacer()

        Button("Accept") {
          onAccept()
          withAnimation {
            showPopup = false
          }
        }
        .padding()
      }
      .padding(.horizontal)
    }
  }
}

extension AddTaskView {
  fileprivate func separator() -> some View {
    Divider()
      .frame(height: 1)
      .background(.gray)
  }
}

#Preview {
  @Previewable @State var showPopup = true
  @Previewable @State var inputText = "Example task"

  AddTaskView(
    showPopup: $showPopup,
    inputText: $inputText,
    onAccept: {}
  )
}
