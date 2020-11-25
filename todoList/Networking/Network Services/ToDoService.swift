//
//  ToDoService.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class ToDoService: NSObject {

    // get all todo's
    func getTodoList(onSuccess: @escaping ([Todo]) -> Void, onResponseError: @escaping (String, Int) -> Void, onError: @escaping (String, Int) -> Void) {
    
        Alamofire.request(Router.getTodoList(1))
            .validate()
            .responseArray { (response: DataResponse<[Todo]>) in
                
                switch response.result {
                case .success(let value):
                    onSuccess(value)
                    
                case .failure(let error):
                    print(error)
                    if response.response?.statusCode == 404 {
                        onResponseError("No internet connection ", 404)
                        break
                    } else {
                        print(error.localizedDescription)
                        onError("Sorry, Something went wrong. Please try again later.", 500)
                        break
                    }
                }
                
        }
    }
    
    // add todo item
    func addTodoListItem(parameters: Parameters, onSuccess: @escaping (Todo) -> Void, onResponseError: @escaping (String, Int) -> Void, onError: @escaping (String, Int) -> Void) {
    
        Alamofire.request(Router.addTodoItem(parameters: parameters))
            .validate()
            .responseObject { (response: DataResponse<Todo>) in
                
                switch response.result {
                case .success(let value):
                    onSuccess(value)
                    
                case .failure(let error):
                    print(error)
                    if response.response?.statusCode == 404 {
                        onResponseError("No internet connection ", 404)
                        break
                    } else {
                        print(error.localizedDescription)
                        onError("Sorry, Something went wrong. Please try again later.", 500)
                        break
                    }
                }
                
        }
    }
    
    // update todo item
    func updateTodoListItem(todoId: Int, parameters: Parameters, onSuccess: @escaping (Todo) -> Void, onResponseError: @escaping (String, Int) -> Void, onError: @escaping (String, Int) -> Void) {
    
        Alamofire.request(Router.updateTodoItem(id: todoId, parameters: parameters))
            .validate()
            .responseObject { (response: DataResponse<Todo>) in
                
                switch response.result {
                case .success(let value):
                    onSuccess(value)
                    
                case .failure(let error):
                    print(error)
                    if response.response?.statusCode == 404 {
                        onResponseError("No internet connection ", 404)
                        break
                    } else {
                        print(error.localizedDescription)
                        onError("Sorry, Something went wrong. Please try again later.", 500)
                        break
                    }
                }
                
        }
    }
    
    // delete todo item
    func deleteTodoListItem(todoId: Int, onSuccess: @escaping (Bool) -> Void, onResponseError: @escaping (String, Int) -> Void, onError: @escaping (String, Int) -> Void) {
    
        Alamofire.request(Router.deleteTodoItem(id: todoId))
            .validate()
            .responseObject { (response: DataResponse<Todo>) in
                
                switch response.result {
                case .success( _):
                    onSuccess(true)
                    
                case .failure(let error):
                    print(error)
                    if response.response?.statusCode == 404 {
                        onResponseError("No internet connection ", 404)
                        break
                    } else {
                        print(error.localizedDescription)
                        onError("Sorry, Something went wrong. Please try again later.", 500)
                        break
                    }
                }
                
        }
    }
    
}
