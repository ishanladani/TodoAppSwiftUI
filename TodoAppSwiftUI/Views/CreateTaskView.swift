//
//  CreateTaskView.swift
//  TodoAppSwiftUI
//
//  Created by ISHAN LADANI on 27/11/21.
//

import SwiftUI

struct CreateTaskView: View {
  @State var taskName: String = ""
  @State var reminderEnabled = false
  @State var selectedTrigger = ReminderType.time
  @State var timeDurationIndex: Int = 0
  @State private var dateTrigger = Date()
  @State private var shouldRepeat = false
  @State private var radius: String = ""
  @Environment(\.presentationMode) var presentationMode

  let triggers = ["Time", "Calendar", "Location"]
  let timeDurations: [Int] = Array(1...59)
  var body: some View {
    NavigationView {
      Form {
        Section {
          HStack {
            Spacer()
            Text("Add Task")
              .font(.title)
              .padding()
            Spacer()
            Button("Save") {
              TaskManager.shared.addNewTask(taskName, makeReminder())
              presentationMode.wrappedValue.dismiss()
            }
            .disabled(taskName.isEmpty ? true : false)
            .padding()
          }
          VStack {
            TextField("Enter name for the task", text: $taskName)
              .padding(.vertical)
            Toggle(isOn: $reminderEnabled) {
              Text("Add Reminder")
            }
            .padding(.vertical)

            if reminderEnabled {
              ReminderView(
                selectedTrigger: $selectedTrigger,
                timeDurationIndex: $timeDurationIndex,
                triggerDate: $dateTrigger,
                shouldRepeat: $shouldRepeat,
                radius: $radius)
                .navigationBarHidden(true)
                .navigationTitle("")
            }
            Spacer()
          }
          .padding()
        }
      }
      .navigationBarTitle("")
      .navigationBarHidden(true)
    }
  }

  func makeReminder() -> Reminder? {
    guard reminderEnabled else {
      return nil
    }
    var reminder = Reminder()
    reminder.reminderType = selectedTrigger
    switch selectedTrigger {
    case .time:
      reminder.timeInterval = TimeInterval(timeDurations[timeDurationIndex] * 60)
    case .calendar:
      reminder.date = dateTrigger
    }
    reminder.repeats = shouldRepeat
    return reminder
  }
}

struct CreateTaskView_Previews: PreviewProvider {
  static var previews: some View {
    CreateTaskView()
  }
}

struct ReminderView: View {
  @Binding var selectedTrigger: ReminderType
  @Binding var timeDurationIndex: Int
  @Binding var triggerDate: Date
  @Binding var shouldRepeat: Bool
  @Binding var radius: String

  var body: some View {
    VStack {
      Picker("Notification Trigger", selection: $selectedTrigger) {
        Text("Time").tag(ReminderType.time)
        Text("Date").tag(ReminderType.calendar)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding(.vertical)
      if selectedTrigger == ReminderType.time {
        Picker("Time Interval", selection: $timeDurationIndex) {
          ForEach(1 ..< 59) { i in
            if i == 1 {
              Text("\(i) minute").tag(i)
            } else {
              Text("\(i) minutes").tag(i)
            }
          }
          .navigationBarHidden(true)
          .padding(.vertical)
        }
      } else if selectedTrigger == ReminderType.calendar {
        DatePicker("Please enter a date", selection: $triggerDate)
          .labelsHidden()
          .padding(.vertical)
      }
      Toggle(isOn: $shouldRepeat) {
        Text("Repeat Notification")
      }
    }
  }
}

