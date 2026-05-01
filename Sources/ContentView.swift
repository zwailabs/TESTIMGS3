import SwiftUI

struct TaskItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    var isCompleted: Bool = false
}

struct TaskSection: Identifiable {
    let id = UUID()
    let title: String
    var tasks: [TaskItem]
    var isExpanded: Bool = true
}

struct ContentView: View {
    @State private var selectedDate = 10
    @State private var selectedTab = "To do"
    
    @State private var sections: [TaskSection] = [
        TaskSection(title: "Morning", tasks: [
            TaskItem(title: "Wake up on time", icon: "⏰"),
            TaskItem(title: "Gym / workout", icon: "🏋️‍♂️")
        ]),
        TaskSection(title: "Workload", tasks: [
            TaskItem(title: "Polish UI / components", icon: "🧩"),
            TaskItem(title: "Share updates with team / client", icon: "📤"),
            TaskItem(title: "Improve portfolio or case study", icon: "📁")
        ]),
        TaskSection(title: "Night", tasks: [
            TaskItem(title: "Plan tomorrow's top task", icon: "📓"),
            TaskItem(title: "No phone 30 mins before sleep", icon: "📵")
        ])
    ]
    
    var body: some View {
        ZStack {
            // Background Color matching the image (off-white)
            Color(red: 0.95, green: 0.95, blue: 0.96).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HeaderView()
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                
                // Calendar Strip
                CalendarStripView(selectedDate: $selectedDate)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                
                // Main Content Card
                VStack(spacing: 0) {
                    // Filter Tabs
                    FilterTabsView(selectedTab: $selectedTab)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    // Task List
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach($sections) { $section in
                                TaskSectionView(section: $section)
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120) // Space for bottom bar
                    }
                }
                .background(Color.white)
                .cornerRadius(32)
                .padding(.top, 20)
                .padding(.horizontal, 16)
                
                Spacer(minLength: 0)
            }
            
            // Bottom Tab Bar & FAB
            VStack {
                Spacer()
                BottomTabBarView()
            }
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hey, Karthik✋🏼")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Let's make progress today!")
                    .font(.custom("Georgia-Italic", size: 16)) // Fallback to a serif italic font
                    .foregroundColor(.black.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: {
                // Toggle theme action
            }) {
                Image(systemName: "sun.max")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
            }
        }
    }
}

// MARK: - Calendar Strip
struct CalendarStripView: View {
    @Binding var selectedDate: Int
    let days = [
        ("Mon", 8), ("Tue", 9), ("Wed", 10), ("Thu", 11), ("Fri", 12), ("Sat", 13)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(days, id: \.1) { day, date in
                VStack(spacing: 8) {
                    Text(day)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(selectedDate == date ? .black : .gray.opacity(0.5))
                    
                    Text("\(date)")
                        .font(.system(size: 16, weight: selectedDate == date ? .semibold : .medium))
                        .foregroundColor(selectedDate == date ? .black : .gray.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    selectedDate == date ?
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color(red: 0.95, green: 0.95, blue: 0.96)) // Inner pill background
                        : nil
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Filter Tabs
struct FilterTabsView: View {
    @Binding var selectedTab: String
    let tabs = ["To do", "Completed", "Pending"]
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    HStack(spacing: 6) {
                        if tab == "To do" {
                            Image(systemName: "sun.max")
                                .font(.system(size: 14))
                        } else if tab == "Completed" {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12))
                        } else {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                        }
                        
                        Text(tab)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(selectedTab == tab ? .white : .gray.opacity(0.7))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(
                        selectedTab == tab ? Color.black : Color.clear
                    )
                    .clipShape(Capsule())
                }
            }
            Spacer(minLength: 0)
        }
        .padding(6)
        .background(Color(red: 0.96, green: 0.96, blue: 0.97))
        .clipShape(Capsule())
    }
}

// MARK: - Task Section
struct TaskSectionView: View {
    @Binding var section: TaskSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: {
                withAnimation(.spring()) {
                    section.isExpanded.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: section.isExpanded ? "arrowtriangle.down.fill" : "arrowtriangle.right.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.black)
                    
                    Text(section.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
            }
            
            if section.isExpanded {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach($section.tasks) { $task in
                        TaskRowView(task: $task)
                    }
                }
                .padding(.leading, 12)
            }
        }
    }
}

// MARK: - Task Row
struct TaskRowView: View {
    @Binding var task: TaskItem
    
    var body: some View {
        HStack(spacing: 14) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    task.isCompleted.toggle()
                }
            }) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(task.isCompleted ? Color.black : Color.clear)
                    )
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(task.isCompleted ? 1 : 0)
                    )
            }
            
            Text(task.icon)
                .font(.system(size: 18))
            
            Text(task.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(task.isCompleted ? .gray : .black.opacity(0.8))
                .strikethrough(task.isCompleted, color: .gray)
            
            Spacer()
        }
    }
}

// MARK: - Bottom Tab Bar
struct BottomTabBarView: View {
    var body: some View {
        HStack {
            // Pill shaped background for tabs
            HStack(spacing: 0) {
                TabBarItem(icon: "house.fill", title: "Home", isSelected: true)
                TabBarItem(icon: "chart.bar.fill", title: "Insights", isSelected: false)
                TabBarItem(icon: "person.fill", title: "Profile", isSelected: false)
            }
            .padding(6)
            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
            .clipShape(Capsule())
            
            Spacer()
            
            // FAB
            Button(action: {
                // Add new task action
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.black)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
            if isSelected {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            } else {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .foregroundColor(isSelected ? .black : .gray.opacity(0.7))
        .padding(.horizontal, isSelected ? 16 : 14)
        .padding(.vertical, 12)
        .background(isSelected ? Color.white : Color.clear)
        .clipShape(Capsule())
        .shadow(color: isSelected ? Color.black.opacity(0.04) : Color.clear, radius: 4, x: 0, y: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
