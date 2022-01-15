//
//  Todo.swift
//  TodoList
//
//  Created by Sun hee Bae on 2022/01/11.
//

import UIKit


// TODO: Codable과 Equatable 추가
struct Todo: Codable, Equatable { // 스트럭트는 codable이라는 프로토콜을 따르면 쉽게 제이슨 형태의 데이터를 만들 수 있고, 혹은 제이슨 형태의 데이터를 스트럭트 형태로 만들 수 있는 징검다리 역할
    let id: Int
    var isDone: Bool
    var detail: String
    var isToday: Bool
    
    mutating func update(isDone: Bool, detail: String, isToday: Bool) {
        // [x] TODO: update 로직 추가
        self.isDone = isDone
        self.detail = detail
        self.isToday = isToday
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        // [x] TODO: 동등 조건 추가
        
        return lhs.id == rhs.id
    }
}

class TodoManager {
    
    static let shared = TodoManager() //single tone object 싱글톤 객체
    
    static var lastId: Int = 0
    
    var todos: [Todo] = []
    
    func createTodo(detail: String, isToday: Bool) -> Todo {
        //[x] TODO: create로직 추가
        
        let nextId = TodoManager.lastId + 1 // new id
        TodoManager.lastId = nextId
        return Todo(id: nextId, isDone: false, detail: detail, isToday: isToday)
    }
    
    func addTodo(_ todo: Todo) {
        // [x] TODO: add로직 추가
        todos.append(todo)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo) {
        // [x] TODO: delete 로직 추가
        
        todos = todos.filter { $0.id != todo.id }
        
        if let index = todos.firstIndex(of: todo) {
            todos.remove(at: index)
        }
        
    }
    
    func updateTodo(_ todo: Todo) {
        //TODO: update 로직 추가
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].update(isDone: todo.isDone, detail: todo.detail, isToday: todo.isToday)
        saveTodo()
    }
    
    func saveTodo() {
        Storage.store(todos, to: .documents, as: "todos.json")
        let json: [String: Any]
    }
    
    func retrieveTodo() {
        todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
        
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
    }
}

class TodoViewModel {
    
    enum Section: Int, CaseIterable {
        case today
        case upcoming
        
        var title: String {
            switch self {
            case .today: return "Today"
            default: return "Upcoming"
            }
        }
    }
    
    private let manager = TodoManager.shared
    
    var todos: [Todo] {
        return manager.todos
    }
    
    var todayTodos: [Todo] {
        return todos.filter { $0.isToday == true }
    }
    
    var upcompingTodos: [Todo] {
        return todos.filter { $0.isToday == false }
    }
    
    var numOfSection: Int {
        return Section.allCases.count
    }
    
    func addTodo(_ todo: Todo) {
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    }
}


