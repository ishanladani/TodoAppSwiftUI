//
//  TaskListView.swift
//  TodoAppSwiftUI
//
//  Created by ISHAN LADANI on 27/11/21.
//

import SwiftUI

struct TaskListView: View {
    
  let deviceID = UUID().uuidString
  @ObservedObject var taskManager = TaskManager.shared
  @State var showNotificationSettingsUI = false
    

  private let maxValue: Double = 100

  var body: some View {
    ZStack {
      VStack {
        HStack {
         Spacer(minLength: 10)
         Image("SwiftUILogo")
                .clipShape(Circle())
          Text(deviceID)
            .font(.title3)
            .foregroundColor(.blue)
          Spacer()
          Button(
            action: {
              // 1
              NotificationManager.shared.requestAuthorization { granted in
                // 2
                if granted {
                  showNotificationSettingsUI = true
                }
              }
            },
            label: {
              Image(systemName: "bell")
                .font(.title)
                .accentColor(.blue)
            })
            .padding(.trailing).alert(isPresented: $showNotificationSettingsUI, title: "Permission Granted", message: "Notification is already enable")
        }
        Text("\(Int(TaskManager.shared .sliderValue.position))%")
          .foregroundColor(.orange)
          .font(.title3)
        HandySlider(sliderValue: taskManager.sliderValue)
        .padding()
        if taskManager.tasks.isEmpty {
          Spacer()
          Text("Please add Todo!")
            .foregroundColor(.blue)
            .font(.title3)
          Spacer()
        } else {
          List(taskManager.tasks) { task in
            TaskCell(task: task)
          }
          .padding()
        }
      }
      AddTaskView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView()
  }
}

struct TaskCell: View {
  var task: Task
  
  var body: some View {
    HStack {
      Button(
        action: {
          TaskManager.shared.markTaskComplete(task: task)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            TaskManager.shared.remove(task: task)
            
          }
        }
        , label: {
          Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 20, height: 20)
            .accentColor(.blue)
        }
      )
      if task.completed {
        Text(task.name)
          .strikethrough()
          .foregroundColor(.blue)
//        TaskManager.shared .sliderValue.position = t
      } else {
        Text(task.name)
          .foregroundColor(.blue)
      }
    }
  }
}

struct AddTaskView: View {
  @State var showCreateTaskView = false

  var body: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Button(
          action: {
            showCreateTaskView = true
          }, label: {
            Text("+")
              .font(.largeTitle)
              .multilineTextAlignment(.center)
              .frame(width: 30, height: 30)
              .foregroundColor(Color.white)
              .padding()
          })
          .background(Color.blue)
          .cornerRadius(40)
          .padding()
          .sheet(isPresented: $showCreateTaskView) {
            CreateTaskView()
          }
      }
      .padding(.bottom)
    }
  }
}


struct HandySlider: View {
    @ObservedObject var sliderValue: SliderValue
    var body: some View {
        HStack {
            Text("0")
            Slider(value: $sliderValue.position, in: 0...100)
            Text("100")
        }
    }
}

public extension View {
    func alert(isPresented: Binding<Bool>,
               title: String,
               message: String? = nil,
               dismissButton: Alert.Button? = nil) -> some View {

        alert(isPresented: isPresented) {
            Alert(title: Text(title),
                  message: {
                    if let message = message { return Text(message) }
                    else { return nil } }(),
                  dismissButton: dismissButton)
        }
    }
}
