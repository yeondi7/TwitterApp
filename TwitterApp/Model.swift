//
//  Model.swift
//  TwitterApp
//
//  Created by 김연지 on 5/8/24.
//

import Foundation

struct Member:Codable {
    let userID: String
    let userName: String
    let profile: String
}

struct SignUp:Codable {
    let success: Bool
    let message: String
    let member: Member
}

struct SignIn: Codable{
    let success: Bool
    let message: String
    let member: Member
    let token: String
}

struct Post: Codable{
    let userID: String
    let content: String
}

struct Posts: Codable{
    let success: Bool
    let message: String
    let documents: [Post]
}
