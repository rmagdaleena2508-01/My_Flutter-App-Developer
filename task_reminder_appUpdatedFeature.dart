import 'dart:async';
import 'dart:io';

// Task Model Class
class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  void displayTask() {
    print('\n--- Task Details ---');
    print('Title: $title');
    print('Description: $description');
    print('Due Date: ${dueDate.day}/${dueDate.month}/${dueDate.year}');
    print('Status: ${isCompleted ? "✅ Completed" : "⏳ Pending"}');
    print('--------------------');
  }

  @override
  String toString() {
    String status = isCompleted ? '✅' : '⏳';
    return '$status Task: $title | Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }
}

// Global lists to store tasks
List<Task> taskList = [];
List<Task> completedTaskList = [];

Future<List<Task>> fetchTasksFromDatabase() async {
  print('\n⏳ Fetching tasks from database...');
  print('Please wait...');

  await Future.delayed(Duration(seconds: 3));

  List<Task> sampleTasks = [
    Task(
      title: 'Complete Dart Assignment',
      description: 'Finish the Task Reminder App project using async/await',
      dueDate: DateTime(2026, 2, 15),
    ),
    Task(
      title: 'Study Flutter Basics',
      description: 'Learn widgets, layouts, and state management',
      dueDate: DateTime(2026, 2, 20),
    ),
    Task(
      title: 'Attend App Development Class',
      description: 'Join the online lecture on mobile app architecture',
      dueDate: DateTime(2026, 2, 10),
    ),
    Task(
      title: 'Submit GitHub Repository',
      description: 'Upload project code to public GitHub repo',
      dueDate: DateTime(2026, 2, 14),
    ),
    Task(
      title: 'Prepare Project Documentation',
      description: 'Write README.md file with project overview and features',
      dueDate: DateTime(2026, 2, 13),
    ),
  ];

  print('✅ Tasks fetched successfully!');
  return sampleTasks;
}

Future<void> addNewTask(Task newTask) async {
  print('\n⏳ Saving new task...');
  print('Please wait...');

  await Future.delayed(Duration(seconds: 3));

  taskList.add(newTask);

  print('✅ Task added successfully!');
  print('Task "${newTask.title}" has been saved.');
}

Future<void> loadAndDisplayTasks() async {
  try {
    List<Task> fetchedTasks = await fetchTasksFromDatabase();
    taskList = fetchedTasks;

    print('\n========================================');
    print('          ALL TASKS');
    print('========================================');

    if (taskList.isEmpty) {
      print('No tasks available.');
    } else {
      for (int i = 0; i < taskList.length; i++) {
        print('\n${i + 1}. ${taskList[i].toString()}');
      }
    }

    print('\n========================================');
  } catch (e) {
    print('❌ Error loading tasks: $e');
  }
}

Future<void> viewTaskDetails(int taskIndex) async {
  if (taskIndex < 0 || taskIndex >= taskList.length) {
    print('❌ Invalid task number!');
    return;
  }

  print('\n⏳ Loading task details...');
  await Future.delayed(Duration(seconds: 2));

  taskList[taskIndex].displayTask();
}

Future<Task> createTaskFromInput() async {
  print('\n--- Add New Task ---');

  stdout.write('Enter task title: ');
  String title = stdin.readLineSync() ?? 'Untitled Task';

  stdout.write('Enter task description: ');
  String description = stdin.readLineSync() ?? 'No description';

  stdout.write('Enter due date (DD): ');
  int day = int.tryParse(stdin.readLineSync() ?? '1') ?? 1;

  stdout.write('Enter due month (MM): ');
  int month = int.tryParse(stdin.readLineSync() ?? '1') ?? 1;

  stdout.write('Enter due year (YYYY): ');
  int year = int.tryParse(stdin.readLineSync() ?? '2026') ?? 2026;

  DateTime dueDate = DateTime(year, month, day);

  return Task(title: title, description: description, dueDate: dueDate);
}

// New Feature: Mark task as completed
Future<void> markTaskAsCompleted(int taskIndex) async {
  if (taskIndex < 0 || taskIndex >= taskList.length) {
    print('❌ Invalid task number!');
    return;
  }

  Task taskToComplete = taskList[taskIndex];

  print('\n⏳ Marking task as completed...');
  print('Please wait...');

  // Simulate database update with 3 second delay
  await Future.delayed(Duration(seconds: 3));

  // Mark the task as completed
  taskToComplete.isCompleted = true;

  // Move task to completed list
  completedTaskList.add(taskToComplete);

  // Remove from active task list
  taskList.removeAt(taskIndex);

  print('✅ Task marked as completed!');
  print('Task "${taskToComplete.title}" has been moved to completed tasks.');
}

// New Feature: Display completed tasks
Future<void> displayCompletedTasks() async {
  print('\n⏳ Loading completed tasks...');
  await Future.delayed(Duration(seconds: 2));

  print('\n========================================');
  print('        COMPLETED TASKS');
  print('========================================');

  if (completedTaskList.isEmpty) {
    print('No completed tasks yet.');
    print('Mark tasks as done to see them here!');
  } else {
    for (int i = 0; i < completedTaskList.length; i++) {
      print('\n${i + 1}. ${completedTaskList[i].toString()}');
    }
    print('\n📊 Total completed: ${completedTaskList.length} task(s)');
  }

  print('========================================');
}

void displayMenu() {
  print('\n========================================');
  print('     TASK REMINDER APP - MENU');
  print('========================================');
  print('1. Load All Tasks');
  print('2. Add New Task');
  print('3. View Task Details');
  print('4. Display All Tasks (Current)');
  print('5. Mark Task as Done');
  print('6. View Completed Tasks');
  print('7. Exit');
  print('========================================');
}

void main() async {
  print('╔════════════════════════════════════════╗');
  print('║   WELCOME TO TASK REMINDER APP        ║');
  print('║   Built with Dart - Async Programming ║');
  print('║   ✨ Now with Task Completion! ✨     ║');
  print('╚════════════════════════════════════════╝');

  bool running = true;

  while (running) {
    displayMenu();
    stdout.write('\nEnter your choice (1-7): ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        // Load all tasks asynchronously
        await loadAndDisplayTasks();
        break;

      case '2':
        // Add new task
        try {
          Task newTask = await createTaskFromInput();
          await addNewTask(newTask);
        } catch (e) {
          print('❌ Error adding task: $e');
        }
        break;

      case '3':
        // View specific task details
        if (taskList.isEmpty) {
          print('\n❌ No tasks available. Please load tasks first!');
        } else {
          stdout.write('\nEnter task number (1-${taskList.length}): ');
          int taskNum = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
          await viewTaskDetails(taskNum - 1);
        }
        break;

      case '4':
        // Display current (active/pending) tasks only
        print('\n========================================');
        print('          CURRENT TASKS (PENDING)');
        print('========================================');
        if (taskList.isEmpty) {
          print('No pending tasks!');
          print('All tasks completed or no tasks loaded yet.');
        } else {
          for (int i = 0; i < taskList.length; i++) {
            print('${i + 1}. ${taskList[i].toString()}');
          }
          print('\n📊 Total pending: ${taskList.length} task(s)');
        }
        print('========================================');
        break;

      case '5':
        // Mark task as completed (NEW FEATURE)
        if (taskList.isEmpty) {
          print('\n❌ No tasks available to mark as done!');
          print('Please load tasks first or add new tasks.');
        } else {
          print('\n--- Mark Task as Done ---');
          print('Current pending tasks:');
          for (int i = 0; i < taskList.length; i++) {
            print('${i + 1}. ${taskList[i].title}');
          }
          stdout.write(
            '\nEnter task number to mark as done (1-${taskList.length}): ',
          );
          int taskNum = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

          try {
            await markTaskAsCompleted(taskNum - 1);
          } catch (e) {
            print('❌ Error marking task as completed: $e');
          }
        }
        break;

      case '6':
        // View completed tasks (NEW FEATURE)
        await displayCompletedTasks();
        break;

      case '7':
        // Exit
        print('\n👋 Thank you for using Task Reminder App!');
        print('📊 Session Summary:');
        print('   - Pending tasks: ${taskList.length}');
        print('   - Completed tasks: ${completedTaskList.length}');
        print('Exiting...');
        running = false;
        break;

      default:
        print('\n❌ Invalid choice! Please enter a number between 1 and 7.');
    }

    // Small delay before showing menu again
    if (running) {
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

