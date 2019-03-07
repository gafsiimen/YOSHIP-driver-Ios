//
//  SocketRepository.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/6/19.
//  Copyright © 2019 MacHD. All rights reserved.
//
import SocketIO


struct SocketRepository {
       static let sharedInstance = SocketRepository()
    
    
    
     func doCheckInternet(){
//        let manager = SocketManager(socketURL: URL(string: "https://rt.box2home.xyz")!, config: [.log(true), .connectParams(["token":token])])
        let manager = SocketManager(socketURL: URL(string: "8.8.8.8")!)
        let socket = manager.defaultSocket
       SetSocketEvents(socket: socket)
        socket.connect()
       
    }
    func SetSocketEvents(socket: SocketIOClient!) {
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print("socket connected")
           
        }
        socket.on(clientEvent: .error) { (data, ack) in
            print("error")
            
        }
     
    }
    
}
