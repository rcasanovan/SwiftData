import SwiftUI

/// A view representing a single task in the task list.
///
/// The `TaskView` displays the title of a task with specific styling, including padding,
/// font size, and color. It is designed to be used within a list of tasks to present
/// individual task information in a user-friendly manner.
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

#if DEBUG

// MARK: Previews

/// A preview for `TaskView` to visualize the view during development.
///
/// This struct provides a sample instance of `TaskView` with a default task title
/// to help developers see how the task will look in the UI.
struct TaskView_Preview {
  struct Preview: View {
    var body: some View {
      TaskView(taskTitle: "Task title")
    }
  }
}

#Preview {
  TaskView(taskTitle: "Task title")
}

#endif
