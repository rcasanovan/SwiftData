import SwiftUI

struct HeaderView: View {
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

      separator()
    }
  }
}

extension HeaderView {
  fileprivate func separator() -> some View {
    Divider()
      .frame(height: 1)
      .background(.gray)
      .padding(.leading)
      .padding(.trailing)
  }
}

#if DEBUG

// MARK: Previews

struct HeaderView_Preview {
  struct Preview: View {
    var body: some View {
      HeaderView(
        deleteAllOnTap: {},
        addNewTaskOnTap: {}
      )
    }
  }
}

#Preview {
  HeaderView(
    deleteAllOnTap: {},
    addNewTaskOnTap: {}
  )
}

#endif
