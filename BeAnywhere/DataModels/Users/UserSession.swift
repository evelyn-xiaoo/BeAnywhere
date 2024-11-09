//
//  UserSession.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/8/24.
//



class UserSession {
    static let shared = UserSession()  // Singleton instance

    var currentUser: FirestoreUser?  // Stores the current user information

    private init() {}  // Private initializer to prevent multiple instances
}
