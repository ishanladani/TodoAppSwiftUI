//
//  TaskListView.swift
//  TodoAppSwiftUI
//
//  Created by ISHAN LADANI on 27/11/21.
//

import SwiftUI

struct TaskListView: View {
    
  var sliderUpdatedValue: Double = 0
  @ObservedObject var taskManager = TaskManager.shared
  @State var showNotificationSettingsUI = false
    
  @State public var sliderValue: Double = 0
  private let maxValue: Double = 100

  var body: some View {
    ZStack {
      VStack {
        HStack {
            Image("SwiftUILogo")
                .clipShape(Circle())
          Text(UUID().uuidString)
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
            .padding(.trailing)
            .sheet(isPresented: $showNotificationSettingsUI) {
              NotificationSettingsView()
            }
        }
        Text("\(Int(self.sliderValue))%")
          .foregroundColor(.orange)
          .font(.title3)
        Slider(value: $sliderValue,
                           in: 0...maxValue)
        .padding()
        if taskManager.tasks.isEmpty {
          Spacer()
          Text("Please add Task!")
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
