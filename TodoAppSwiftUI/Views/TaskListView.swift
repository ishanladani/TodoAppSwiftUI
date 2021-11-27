//
//  TaskListView.swift
//  TodoAppSwiftUI
//
//  Created by ISHAN LADANI on 27/11/21.
//

import SwiftUI

struct TaskListView: View {
  @ObservedObject var taskManager = TaskManager.shared
  @State var showNotificationSettingsUI = false

  var body: some View {
    ZStack {
      VStack {
        HStack {
            Image("SwiftUILogo")
                .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.red, lineWidth: 5))
          Spacer()
          Text("Organizer Plus")
            .font(.title)
            .foregroundColor(.pink)
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
                .accentColor(.pink)
            })
            .padding(.trailing)
            .sheet(isPresented: $showNotificationSettingsUI) {
              NotificationSettingsView()
            }
        }
        .padding()
        if taskManager.tasks.isEmpty {
          Spacer()
          Text("No Tasks!")
            .foregroundColor(.pink)
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
        }, label: {
          Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 20, height: 20)
            .accentColor(.pink)
        })
      if task.completed {
        Text(task.name)
          .strikethrough()
          .foregroundColor(.pink)
      } else {
        Text(task.name)
          .foregroundColor(.pink)
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
          .background(Color.pink)
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
