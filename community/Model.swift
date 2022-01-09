//
//  Model.swift
//  community
//
//  Created by yeop on 2022/01/07.
//

import Foundation

struct Auth: Codable {
    let jwt: String
    let user: User
}

struct User: Codable {
    let id: Int
    let username: String
    let email: String
}

typealias Posts = [Post]

struct Post: Codable {
    let id: Int
    let text: String
    let user: User
    let created_at: String
    let updated_at: String
    let comments: Comments
}

typealias Comments = [Comment]

struct Comment: Codable{
    let id: Int
    let comment: String
    let user: Int
    let post: Int
    let created_at: String
    let updated_at: String
}

typealias DetailComments = [DetailComment]

struct DetailComment: Codable{
    let id: Int
    let comment: String
    let user: User
    let created_at: String
    let updated_at: String
}
