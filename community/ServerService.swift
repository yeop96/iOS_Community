//
//  ServerService.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import Foundation

class ServerService{
    
    func requestSignIn(identifier: String, password: String, _ completion: @escaping (Auth?) -> Void){
        
        //전송할 값
        let param = "identifier=\(identifier)&password=\(password)"
        let paramData = param.data(using: .utf8)
        
        //URL 객체 정의
        let url = URL(string: "http://test.monocoding.com:1231/auth/local")
        
        //URLRequest 객체 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        //(응답 메시지(Data), 응답 정보(URLResponse), 오류 정보(Error))
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            //서버가 응답이 없거나 통신이 실패
            if let e = error{
                print("e : \(e.localizedDescription)")
                return
            }
            
            if let data = data, let authData = try?
                JSONDecoder().decode(Auth.self, from: data){
                completion(authData)
                return
            }
            completion(nil)
            
            
        }//task - end
        
        //post 전송
        task.resume()
        
    }
    
    func requestSignUp(username: String, email: String, password: String, _ completion: @escaping (Auth?) -> Void){
        
        let param = "username=\(username)&email=\(email)&password=\(password)"
        let paramData = param.data(using: .utf8)
        
        //URL 객체 정의
        let url = URL(string: "http://test.monocoding.com:1231/auth/local/register")
        
        //URLRequest 객체 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        //(응답 메시지(Data), 응답 정보(URLResponse), 오류 정보(Error))
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            //서버가 응답이 없거나 통신이 실패
            if let e = error{
                print("e : \(e.localizedDescription)")
                return
            }
            
            if let data = data, let authData = try?
                JSONDecoder().decode(Auth.self, from: data){
                completion(authData)
                return
            }
            completion(nil)
            
            
        }//task - end
        
        //post 전송
        task.resume()
        
    }
    
    func requestGetPost(jwt: String, _ completion: @escaping (Posts?) -> Void) {
        if let url = URL(string: "http://test.monocoding.com:1231/posts?_sort=created_at:desc"){
            
            var request = URLRequest.init(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request){ (data, response, error) in
               
                if let e = error{
                    print("e : \(e.localizedDescription)")
                    return
                }
                
                if let data = data, let postsData = try?
                    JSONDecoder().decode(Posts.self, from: data){
                    completion(postsData)
                    return
                }
                completion(nil)
                
            }.resume() //URLSession - end
            
        }
    }
    
    func requestPost(jwt: String, text: String, _ completion: @escaping (Posts?) -> Void) {
        
        let param = "text=\(text)"
        let paramData = param.data(using: .utf8)
        
        //URL 객체 정의
        let url = URL(string: "http://test.monocoding.com:1231/posts")
        
        //URLRequest 객체 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        //(응답 메시지(Data), 응답 정보(URLResponse), 오류 정보(Error))
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            //서버가 응답이 없거나 통신이 실패
            if let e = error{
                print("e : \(e.localizedDescription)")
                return
            }
            
            if let data = data, let postsData = try?
                JSONDecoder().decode(Posts.self, from: data){
                completion(postsData)
                return
            }
            completion(nil)
            
            
        }//task - end
        
        //post 전송
        task.resume()

    }
    
    func requestGetComment(jwt: String, post: String, _ completion: @escaping (DetailComments?) -> Void) {
        if let url = URL(string: "http://test.monocoding.com:1231/comments?post=\(post)"){
            
            var request = URLRequest.init(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
            print(jwt)
            
            URLSession.shared.dataTask(with: request){ (data, response, error) in
               
                if let e = error{
                    print("e : \(e.localizedDescription)")
                    return
                }
                
                if let data = data, let commentsData = try?
                    JSONDecoder().decode(DetailComments.self, from: data){
                    completion(commentsData)
                    return
                }
                completion(nil)
                
            }.resume() //URLSession - end
            
        }
    }
    
    func requestPostComment(jwt: String, comment: String, post: String, _ completion: @escaping (Comment?) -> Void) {
        
        let param = "comment=\(comment)&post=\(post)"
        let paramData = param.data(using: .utf8)
        
        //URL 객체 정의
        let url = URL(string: "http://test.monocoding.com:1231/comments")
        
        //URLRequest 객체 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        //(응답 메시지(Data), 응답 정보(URLResponse), 오류 정보(Error))
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            //서버가 응답이 없거나 통신이 실패
            if let e = error{
                print("e : \(e.localizedDescription)")
                return
            }
            
            if let data = data, let postsData = try?
                JSONDecoder().decode(Comment.self, from: data){
                completion(postsData)
                return
            }
            completion(nil)
            
            
        }//task - end
        
        //post 전송
        task.resume()

    }
    
    
    
    
    
}
