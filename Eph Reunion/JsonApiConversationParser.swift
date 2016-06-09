//
//  JsonApiConversationParser.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/30/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class JsonApiConversationParser: NSObject {

    static func parse(json: NSDictionary) -> [Conversation]? {
        print(json)
        var convoHolders: [JsonApiConvoHolder] = [JsonApiConvoHolder]()
        if let dataArray = json["data"] as? [[String : AnyObject]] {
            convoHolders = Eson().fromJsonArray(dataArray, clazz: JsonApiConvoHolder.self)!
        }else{
            convoHolders = [Eson().fromJsonDictionary(json["data"] as? [String : AnyObject], clazz: JsonApiConvoHolder.self)!]
        }
        let conversations: [Conversation]? = convoHolders.map {$0.attributes!}
        let included: [NSDictionary] = json["included"] as? [NSDictionary] ?? [NSDictionary]()
        var users = [Eph]()
        var messages = [Message]()
        for dict in included {
            let type = dict["type"] as? String
            if type == "user" {
                users.append(Eson().fromJsonDictionary(dict["attributes"] as? [String: AnyObject], clazz: Eph.self)!)
            }else if type == "message" {
                messages.append(Eson().fromJsonDictionary(dict["attributes"] as? [String: AnyObject], clazz: Message.self)!)
            }
        }
        if convoHolders.count > 0 {
            for i in 0...convoHolders.count - 1 {
                let convoHolder = convoHolders[i]
                let conversation = conversations![i]
                
                let relationships = convoHolder.relationships!
                let convoUsers = relationships["users"]?["data"] as? [NSDictionary]
                for userDict in convoUsers! {
                    if userDict["id"] as? String != String(Eph.currentUser!.objectId) {
                        let userId = Int((userDict["id"] as? String)!)
                        for user in users {
                            if userId == user.objectId {
                                conversation.user = user
                            }
                        }
                    }
                }
                let convoMessages = relationships["last-message"]?["data"] as? [NSDictionary]
                let msgId = Int((convoMessages?.first!["id"] as? String)!)
                for msg in messages {
                    if msgId == msg.objectId {
                        conversation.lastMessage = msg.body
                    }
                }
            }
        }
        return conversations
    }
}
