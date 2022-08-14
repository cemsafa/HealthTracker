//
//  ChatVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-14.
//

import UIKit
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView
import SwiftUI

class ChatVC: MessagesViewController {
    
    let currentUser = UserData.user!
    
    var otherUserName: String?
    var otherUserId: String?
    var messages: [Message] = []
    
    private var docReference: DocumentReference?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = otherUserName ?? "Chat"
        
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
    }
    
    func createNewChat() {
        let users = [self.currentUser.id, self.otherUserId]
        let data: [String: Any] = [
            "users": users
        ]
        
        let db = Firestore.firestore().collection("Chats")
        db.addDocument(data: data) { (error) in
            if let error = error {
                Alert.showAlertControllerWith(title: "Unable to create chat", message: "\(error)", onVC: self, style: .alert, buttons: ["OK"])  { success, index in
                    if index == 0 {
                        return
                    }
                }
            } else {
                self.loadChat()
            }
        }
    }
    
    func loadChat() {
        let db = Firestore.firestore().collection("Chats").whereField("users", arrayContains: currentUser.id ?? "First user not found.")
        db.getDocuments { snapshot, error in
            if let error = error {
                Alert.showAlertControllerWith(title: "Error", message: "\(error)", onVC: self, style: .alert, buttons: ["OK"]) { success, index in
                    if index == 0 {
                        return
                    }
                }
            } else {
                guard let queryCount = snapshot?.documents.count else { return }
                if queryCount == 0 {
                    self.createNewChat()
                } else if queryCount >= 1 {
                    for doc in snapshot!.documents {
                        let chat = Chat(dictionary: doc.data())
                        if ((chat?.users.contains(self.otherUserId!)) != nil) {
                            self.docReference = doc.reference
                            doc.reference.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                if let error = error {
                                    Alert.showAlertControllerWith(title: "Error", message: "\(error)", onVC: self, style: .alert, buttons: ["OK"]) { success, index in
                                        if index == 0 {
                                            return
                                        }
                                    }
                                } else {
                                    self.messages.removeAll()
                                    for message in threadQuery!.documents {
                                        let msg = Message(dictionary: message.data())
                                        self.messages.append(msg!)
                                    }
                                    self.messagesCollectionView.reloadData()
                                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                                }
                            })
                            return
                        }
                    }
                    self.createNewChat()
                } else {
                    Alert.showAlertControllerWith(message: "Something happened.", onVC: self, buttons: ["OK"], completion: nil)
                }
            }
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    private func save(_ message: Message) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                Alert.showAlertControllerWith(message: "Error Sending message: \(error)", onVC: self, buttons: ["OK"])  { success, index in
                    if index == 0 {
                        return
                    }
                }
            }
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        })
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.id!, senderName: currentUser.name!)
        insertNewMessage(message)
        save(message)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
    }
}

// MARK: - MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate

extension ChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return Sender(senderId: currentUser.id!, displayName: currentUser.name!)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            Alert.showAlertControllerWith(message: "No messages to display", onVC: self, buttons: ["OK"], completion: nil)
            return 0
        } else {
            return messages.count
        }
    }
    
    func backgroundColor(for message: MessageType, at indexpath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(named: "AccentColor")! : .lightGray
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}
