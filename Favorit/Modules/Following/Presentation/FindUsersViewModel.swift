//
//  FindUsersViewModel.swift
//  Favorit
//
//  Created by ONS on 28/11/23.
//

import Foundation

/*
Main user -
 nazmulla@gmail.com
 656ad9b5fe59756767686071
 
 eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTZhZDliNWZlNTk3NTY3Njc2ODYwNzEiLCJuYW1lIjoiTmF6bXVsIEh1ZGEiLCJlbWFpbCI6Im5hem11bGxhQGdtYWlsLmNvbSIsImNpdHkiOiJEaGFrYSIsImNvdW50cnkiOiJCYW5nbGFkZXNoIiwiZm9sbG93ZXJzIjowLCJmb2xsb3dpbmciOjAsImFjdGl2ZSI6dHJ1ZSwiY3JlYXRlZEF0IjoiMjAyMy0xMi0wMlQwNzoxNjowNS4wODVaIiwidXBkYXRlZEF0IjoiMjAyMy0xMi0wMlQwNzoxNjowNS4wODVaIiwiaWF0IjoxNzAxNTIxMjc3LCJleHAiOjE3MDE2MDc2Nzd9.OvFOv9h3DZo-9mg14VXWQ4T3zJzDLPQW4zWFehmZ808

 Follower user -
 nazmul@gmail.com
 6554350937d3b769f986e4f0
 eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTU0MzUwOTM3ZDNiNzY5Zjk4NmU0ZjAiLCJuYW1lIjoiTmF6bXVsIEh1ZGEiLCJlbWFpbCI6Im5hem11bEBnbWFpbC5jb20iLCJjaXR5IjoiRGhha2EiLCJjb3VudHJ5IjoiQmFuZ2xhZGVzaCIsImF2YXRhciI6Imh0dHA6Ly8xMDMuMTA3LjE4NC4xNTk6ODAwMC91cGxvYWRzL3VzZXJzL05hem11bF9IdWRhXzE3MDAwMTc0MTY5MjIuanBlZyIsImZvbGxvd2VycyI6MCwiZm9sbG93aW5nIjowLCJhY3RpdmUiOnRydWUsImNyZWF0ZWRBdCI6IjIwMjMtMTEtMTVUMDM6MDM6MzcuNjI3WiIsInVwZGF0ZWRBdCI6IjIwMjMtMTEtMTVUMDM6MDM6MzcuNjI3WiIsImlhdCI6MTcwMTUyMTIyMywiZXhwIjoxNzAxNjA3NjIzfQ.cFDsFr419Ms7L2t3Diys2_UqeM3gk9B7tMEEAsmg-8I
*/

class FindUsersViewModel {
    
    private var users = [Following]()
    
    var numberOfUsers: Int {
        return users.count
    }
    
    func userForIndex(_ index: Int) -> UserProtocol? {
        guard index >= 0 || index < numberOfUsers else {
            return nil
        }
        
        return users[index]
    }
    
    func getFollowers(handler: @escaping (Result<[UserProtocol], Error>) -> Void) {
        
    }
}
