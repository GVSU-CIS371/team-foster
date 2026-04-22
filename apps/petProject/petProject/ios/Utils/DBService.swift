//
//  DBService.swift
//  petProject
//
//  Created by Aaron Foster on 3/31/26.
//

import SwiftUI
import Combine
import FirebaseFirestore

class DBService: ObservableObject {
    static let shared = DBService()
    
    private let cm: ConnectionManager
    private let cu = ConnectionUtilsIOS()
    
    let db = Firestore.firestore()
    
    init(cm: ConnectionManager = .shared) {
        self.cm = cm
        
        /*cm.register(event: "get") {data, reply in
            print("get command received to phone from watch")
            
            do{
                let decoded = try JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: data)
                let type = data["type"] as? String ?? ""
            } catch {
                print("Error decoding data")
            }
        }*/
    }
    
    func addDocumentSnapshotListener<T: Codable & Identifiable>(collectName: String, filters: [Filter] = [], docChange: @escaping (Result<T, Error>) -> Void) async -> ListenerRegistration? {
    
        do{
            let collect: Query = queryCollection(collectName: collectName, filters: filters)
            let doc = try await collect.getDocuments().documents.first ?? nil
            guard doc != nil else {
                return nil
            }
            let docRef = doc!.reference
            let listener = docRef.addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else{
                    print ("Error fetching collections")
                    return
                }
                do {
                    print("Snapshot Data \(String(describing: snapshot.data()))")
                    
                    if snapshot.exists{
                        print("Found document")
                        let doc = try snapshot.data(as: T.self)
                        print(doc)
                        docChange(.success(doc))
                    } else {
                        docChange(.failure(DBError.notFound))
                    }
                    
                } catch {
                    print("Error decoding Firebase document: \(error.localizedDescription)")
                    docChange(.failure(error))
                }
            }
            
            return listener
        }catch {print("Error getting document: \(error.localizedDescription)")}

        return nil
    }
    
    func addNamedDocumentSnapshotListener<T: Codable & Identifiable>(collectName: String, docName: String, filters: [Filter] = [], docChange: @escaping (Result<T, Error>) -> Void) -> ListenerRegistration {
            let docRef = db.collection(collectName).document(docName)

            let listener = docRef.addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else{
                    print ("Error fetching collections")
                    return
                }
                do {
                    print("Snapshot Data \(String(describing: snapshot.data()))")
                    
                    if snapshot.exists{
                        print("Found document")
                        let doc = try snapshot.data(as: T.self)
                        print(doc)
                        docChange(.success(doc))
                    } else {
                        docChange(.failure(DBError.notFound))
                    }
                    
                } catch {
                    print("Error decoding Firebase document: \(error.localizedDescription)")
                    docChange(.failure(error))
                }
            }

            return listener
    }
    
    
    func addCollectionSnapshotListener<T: Codable & Identifiable>(collectName: String, filters: [Filter] = [], collectChange: @escaping (Result<T, Error>) -> Void) -> ListenerRegistration {
            let collect: Query = queryCollection(collectName: collectName, filters: filters)
            
        let listener = collect.addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else{
                    print ("Error fetching collections \(error!)")
                    return
                }
                
                do {
                    for change in snapshot.documentChanges {
                        switch change.type {
                        case .added, .modified:
                            let collect = try change.document.data(as: T.self)
                            collectChange(.success(collect))
                        default:
                            break
                        }
                        
                    }
                } catch {
                    print("Error decoding Firebase document: \(error)")
                    collectChange(.failure(error))
                }
            }
        
        return listener
    }
    
    func createDoc<T: Codable>(collectName: String, data: T) async{
        let collect = db.collection(collectName)
        
        do {
            try collect.addDocument(from: data)
        } catch {
            print("Failed to add document")
        }
        
    }
    
    func createNamedDoc<T: Codable>(collectName: String, docName: String, data: T) async{
        let collect = db.collection(collectName)
        
        do {
            try collect.document(docName).setData(from: data)

        } catch {
            print("Failed to add document")
        }
        
    }
    
    func queryCollection(collectName: String, filters: [Filter]) -> Query {
        var collect: Query = db.collection(collectName)
        
        filters.forEach { operation in
            switch operation.op {
            case .EqualTo:
                collect = collect.whereField(operation.from, isEqualTo: operation.to)
            case .LessThan:
                collect = collect.whereField(operation.from, isLessThan: operation.to)
            case .LessThanOrEqualTo:
                collect = collect.whereField(operation.from, isLessThanOrEqualTo: operation.to)
            case .GreaterThan:
                collect = collect.whereField(operation.from, isGreaterThan: operation.to)
            case .GreaterThanOrEqualTo:
                collect = collect.whereField(operation.from, isGreaterThanOrEqualTo: operation.to)
            case .In:
                if let opToArray = operation.to as? [Any] {
                    collect = collect.whereField(operation.from, in: opToArray)
                }
            case .NotIn:
                if let opToArray = operation.to as? [Any] {
                    collect = collect.whereField(operation.from, notIn: opToArray)
                }
            case .Contains:
                if let opToArray = operation.to as? [Any] {
                    collect = collect.whereField(operation.from, arrayContainsAny: opToArray)
                }
            default:
                break
            }
            
        }
        
        return collect
    }
    
    func readDoc<T: Codable>(collectName: String, filters: [Filter] = []) async -> Result<T, Error> {
        do{
        let collect: Query =  queryCollection(collectName: collectName, filters: filters)
        let doc = try await collect.getDocuments().documents.first ?? nil
        guard doc != nil && doc!.exists else {return .failure(DBError.notFound)}
        let tData: T = try doc!.data(as: T.self)
 
            return .success(tData)
            
        } catch {
            print("Failed to get document")
            return .failure(error)
        }
    }
    
    func readNamedDoc<T: Codable>(collectName: String, docName: String, filters: [Filter] = []) async -> Result<T, Error> {
        do{
            let docRef = db.collection(collectName).document(docName)
            let doc = try await docRef.getDocument()
            guard doc.exists else {return .failure(DBError.notFound)}
            let tData: T = try doc.data(as: T.self)
 
            return .success(tData)
            
        } catch {
            print("Failed to get document")
            return .failure(error)
        }
    }
    
    func readCollection<T: Codable>(collectName: String, filters: [Filter] = []) async -> Result<[T], Error> {
        do{
            let collect: Query = queryCollection(collectName: collectName, filters: filters)
            let docs = try await collect.getDocuments()
            var data: [T] = []
            
            try docs.documents.forEach { doc in
                do{
                    let tData: T = try doc.data(as: T.self)
                    data.append(tData)
                }catch{
                    throw error
                }
            }
            
            return .success(data)
            
        } catch {
            print("Failed to get collection \(collectName): \(error)")
            return .failure(error)
        }
    }
    
    func updateDoc<T: Codable>(collectName: String, data: T, filters: [Filter] = []) async {
        let collect: Query = queryCollection(collectName: collectName, filters: filters)
        
        do{
            let doc = try await collect.getDocuments()
            print("UPDATE DOC \(doc)")
            guard let docRef = doc.documents.first?.reference else {
                print("FAILED TO UPDATE DOC")
                await createDoc(collectName: collectName, data: data)
                return
            }
            print("UPDATE DOC REF \(docRef)")
            let encoded = try Firestore.Encoder().encode(data)
            try await docRef.updateData(encoded)

        } catch {
            print("Failed to update document")
        }
    }
    
    func updateNamedDoc<T: Codable>(collectName: String, docName: String, data: T) async {
        let docPath = "\(collectName)/\(docName)"
        let docRef = db.document(docPath)
        

        do {
            let doc = try await docRef.getDocument()
            print("UPDATE NAMED DOC \(doc)")

            guard doc.exists else {
                print("FAILED TO UPDATE NAMED DOC")
                await createNamedDoc(collectName: collectName, docName: docName, data: data)
                return
           }
            
            let encoded = try Firestore.Encoder().encode(data)
            try await docRef.updateData(encoded)

        } catch {
            print("Failed to update named document \(docName)")
        }
    }
        
    func deleteDoc(collectName: String, filters: [Filter] = []) async{
        let collect: Query = queryCollection(collectName: collectName, filters: filters)
        
        do{
            let docs = try await collect.getDocuments()
            guard let docRef = docs.documents.first?.reference else {
                print("Failed to get doc to delete")
                return
            }
        
            try await docRef.delete()
        } catch {
            print("Failed to delete document")
        }
    }
    
    func deleteNamedDoc(collectName: String, docName: String) async{
        let docPath = "\(collectName)/\(docName)"
        let docRef = db.document(docPath)
        do {
            try await docRef.delete()
        } catch {
            print("Failed to delete document \(docName)")
        }
    }
    
    func deleteField(collectName: String, docName:String, fieldName: String) async{
        let docPath = "\(collectName)/\(docName)"
        let docRef = db.document(docPath)
        do {
            try await docRef.setData([fieldName: FieldValue.delete()], merge: true)

        } catch {
            print("Failed to delete field \(fieldName)")
        }
    }
    
    func setUpdateTime() async {
        let collectName = CollectionNames.users.rawValue
        let docName = AuthServiceIOS.shared.userID!
        let docPath = "\(collectName)/\(docName)"
        let docRef = db.document(docPath)
        do {
            try await docRef.updateData(["last_update": FieldValue.serverTimestamp()])
        } catch {
            print("Failed to set update time")
        }
    }
}
