import SwiftUI

struct TaskView: View {
  let taskTitle: String

  var body: some View {
    Text(taskTitle)
      .padding(.top, 15)
      .padding(.bottom, 15)
      .padding(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundColor(.black)
      .font(.title2)
      .background(Color.white)
  }
}

#Preview {
  TaskView(taskTitle: "Task title")
}
