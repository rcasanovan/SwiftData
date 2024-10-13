import SwiftUI

/// A view representing the header section of the task list.
///
/// The `HeaderView` contains buttons for deleting all tasks and adding a new task,
/// as well as a title displaying the demo name. It provides a user interface
/// element for managing tasks and enhancing user interaction in the task list.
struct HeaderView: View {
  let isDeleteAllDisabled: Bool
  let deleteAllOnTap: (() -> Void)
  let addNewTaskOnTap: (() -> Void)

  var body: some View {
    VStack {
      HStack {
        Button(action: {
          deleteAllOnTap()
        }) {
          Text("-")
            .font(.title2)
        }
        .padding(.leading)
        .disabled(isDeleteAllDisabled)

        Spacer()

        Text("SwiftData demo")
          .foregroundColor(.black)
          .font(.title)
          .frame(maxWidth: .infinity)

        Spacer()

        Button(action: {
          addNewTaskOnTap()
        }) {
          Text("+")
            .font(.title2)
        }
        .padding(.trailing)
      }
      .padding([.horizontal, .bottom])
      .background(.white)
    }
  }
}

#if DEBUG

// MARK: Previews

/// A preview for `HeaderView` to visualize the view during development.
///
/// This struct provides a sample instance of `HeaderView` with empty closures
/// for the button actions, allowing developers to see the header layout without
/// executing any functionality.
struct HeaderView_Preview {
  struct Preview: View {
    let isDeleteAllDisabled: Bool

    var body: some View {
      HeaderView(
        isDeleteAllDisabled: isDeleteAllDisabled,
        deleteAllOnTap: {},
        addNewTaskOnTap: {}
      )
    }
  }
}

#Preview {
  HeaderView(
    isDeleteAllDisabled: false,
    deleteAllOnTap: {},
    addNewTaskOnTap: {}
  )
}

#Preview {
  HeaderView(
    isDeleteAllDisabled: true,
    deleteAllOnTap: {},
    addNewTaskOnTap: {}
  )
}

#endif
