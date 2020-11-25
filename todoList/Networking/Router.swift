//
//  Router.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

    static let baseURLString = "https://jsonplaceholder.typicode.com"

    case getTodoList(Int)
    case addTodoItem(parameters: Parameters)
    case updateTodoItem(id: Int, parameters: Parameters)
    case deleteTodoItem(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getTodoList:
                return .get
        case .addTodoItem:
            return .post
        case .updateTodoItem:
            return .put
        case .deleteTodoItem:
            return .delete
        }
    }
    
    var path: String {
        switch self {
            case .getTodoList:
                return "/todos"
            case .addTodoItem:
                return "/todos"
        case .updateTodoItem(let id, _):
                return "/todos/\(id)"
            case .deleteTodoItem(let id):
                return "/todos/\(id)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .getTodoList(id):
                return ("/todos", ["userId": id])
            default:
                return ("", [:])
            }
        }()
        
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .getTodoList(_), .deleteTodoItem(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: result.parameters)
        case .addTodoItem(let parameters), .updateTodoItem(_, let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
}

