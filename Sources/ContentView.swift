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
            // Background - ensure it ignores safe areas to fill the whole screen
            Color(red: 0.96, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HeaderView()
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                
                // Calendar
                CalendarStripView(selectedDate: $selectedDate)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                
                // Card
                VStack(spacing: 0) {
                    FilterTabsView(selectedTab: $selectedTab)
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach($sections) { $section in
                                TaskSectionView(section: $section)
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the card fill available space
                .background(Color.white)
                .cornerRadius(32)
                .padding(.top, 24)
                .padding(.horizontal, 16)
                .padding(.bottom, -40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            // Bottom Bar Overlay
            VStack {
                Spacer()
                BottomTabBarView()
                    .padding(.bottom, 10)
            }
            .ignoresSafeArea(.keyboard)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Header
struct HeaderView: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hey, Karthik👋🏼")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Let's make progress today!")
                    .font(.custom("Georgia-Italic", size: 17))
                    .italic()
                    .foregroundColor(.black.opacity(0.6))
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "sun.max")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            }
        }
    }
}

// MARK: - Calendar
struct CalendarStripView: View {
    @Binding var selectedDate: Int
    let days = [("Mon", 8), ("Tue", 9), ("Wed", 10), ("Thu", 11), ("Fri", 12), ("Sat", 13)]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(days, id: \.1) { day, date in
                VStack(spacing: 6) {
                    Text(day)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(selectedDate == date ? .black : .gray.opacity(0.5))
                    Text("\(date)")
                        .font(.system(size: 16, weight: selectedDate == date ? .bold : .medium))
                        .foregroundColor(selectedDate == date ? .black : .gray.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    selectedDate == date ?
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(red: 0.94, green: 0.94, blue: 0.96))
                        : nil
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedDate = date }
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Tabs
struct FilterTabsView: View {
    @Binding var selectedTab: String
    let tabs = ["To do", "Completed", "Pending"]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                }) {
                    HStack(spacing: 6) {
                        if tab == "To do" { Image(systemName: "sun.max").font(.system(size: 12)) }
                        else if tab == "Completed" { Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)) }
                        else { Image(systemName: "clock").font(.system(size: 10)) }
                        
                        Text(tab)
                            .font(.system(size: 14, weight: .semibold))
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundColor(selectedTab == tab ? .white : .gray)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(selectedTab == tab ? Color.black : Color.clear)
                    .clipShape(Capsule())
                }
            }
            Spacer()
        }
        .padding(4)
        .background(Color(red: 0.96, green: 0.96, blue: 0.97))
        .clipShape(Capsule())
    }
}

// MARK: - Sections & Rows
struct TaskSectionView: View {
    @Binding var section: TaskSection
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: { withAnimation { section.isExpanded.toggle() } }) {
                HStack(spacing: 8) {
                    Image(systemName: section.isExpanded ? "arrowtriangle.down.fill" : "arrowtriangle.right.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.black)
                    Text(section.title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            if section.isExpanded {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach($section.tasks) { $task in
                        TaskRowView(task: $task)
                    }
                }
                .padding(.leading, 18)
            }
        }
    }
}

struct TaskRowView: View {
    @Binding var task: TaskItem
    var body: some View {
        HStack(spacing: 14) {
            Button(action: { withAnimation { task.isCompleted.toggle() } }) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1.5)
                    .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(task.isCompleted ? Color.black : Color.clear))
                    .frame(width: 22, height: 22)
                    .overlay(Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundColor(.white).opacity(task.isCompleted ? 1 : 0))
            }
            Text(task.icon).font(.system(size: 20))
            Text(task.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(task.isCompleted ? .gray : .black.opacity(0.85))
                .strikethrough(task.isCompleted, color: .gray)
            Spacer()
        }
    }
}

// MARK: - Bottom Bar
struct BottomTabBarView: View {
    @State private var selectedTab = "Home"
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 0) {
                TabBarItem(icon: "house.fill", title: "Home", currentSelection: $selectedTab)
                TabBarItem(icon: "chart.bar.fill", title: "Insights", currentSelection: $selectedTab)
                TabBarItem(icon: "person.fill", title: "Profile", currentSelection: $selectedTab)
            }
            .padding(6)
            .background(Color(red: 0.94, green: 0.94, blue: 0.96))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
            
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.black)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    @Binding var currentSelection: String
    
    var isSelected: Bool { currentSelection == title }
    
    var body: some View {
        Button(action: { withAnimation(.spring()) { currentSelection = title } }) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 18))
                if isSelected {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .foregroundColor(isSelected ? .black : .gray.opacity(0.6))
            .padding(.vertical, 12)
            .padding(.horizontal, isSelected ? 20 : 18)
            .background(isSelected ? Color.white : Color.clear)
            .clipShape(Capsule())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
