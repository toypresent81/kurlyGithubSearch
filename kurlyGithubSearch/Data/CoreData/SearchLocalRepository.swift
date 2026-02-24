//
//  SearchLocalRepository.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import CoreData

protocol SearchLocalRepositoryType {
    func save(keyword: String)
    func fetchRecent(count: Int) -> [RecentSearchEntity]
    func fetchAutocomplete(keyword: String) -> [RecentSearchEntity]
    func delete(keyword: String)
    func deleteAll()
}

final class SearchLocalRepository: SearchLocalRepositoryType {
    
    private let context = CoreDataManager.shared.context
    
    //MARK: - 저장
    func save(keyword: String) {
        delete(keyword: keyword)
        
        let entity = RecentSearchEntity(context: context)
        entity.id = UUID()
        entity.keyword = keyword
        entity.searchedAt = Date()
        
        trimToLimit(10)
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - 불러오기
    func fetchRecent(count: Int = Constant.recentFetchCount) -> [RecentSearchEntity] {
        let request: NSFetchRequest<RecentSearchEntity> = RecentSearchEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "searchedAt", ascending: false)
        ]
        request.fetchLimit = count
        
        return (try? context.fetch(request)) ?? []
    }
    
    //MARK: - 자동검색 불러오기
    func fetchAutocomplete(keyword: String) -> [RecentSearchEntity] {
        let request: NSFetchRequest<RecentSearchEntity> = RecentSearchEntity.fetchRequest()
        request.predicate = NSPredicate(format: "keyword CONTAINS[c] %@", keyword)
        request.sortDescriptors = [
            NSSortDescriptor(key: "searchedAt", ascending: false)
        ]
        
        return (try? context.fetch(request)) ?? []
    }
    
    //MARK: - 개별검색삭제
    func delete(keyword: String) {
        let request: NSFetchRequest<RecentSearchEntity> = RecentSearchEntity.fetchRequest()
        request.predicate = NSPredicate(format: "keyword == %@", keyword)
        
        if let results = try? context.fetch(request) {
            results.forEach { context.delete($0) }
            CoreDataManager.shared.saveContext()
        }
    }
    
    //MARK: - 전체검색삭제
    func deleteAll() {
        let request: NSFetchRequest<NSFetchRequestResult> = RecentSearchEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? context.execute(deleteRequest)
        CoreDataManager.shared.saveContext()
    }
    
    private func trimToLimit(_ limit: Int) {
        let request: NSFetchRequest<RecentSearchEntity> = RecentSearchEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "searchedAt", ascending: false)
        ]
        
        if let results = try? context.fetch(request),
           results.count > limit {
            let overflow = results.suffix(from: limit)
            overflow.forEach { context.delete($0) }
        }
    }
}

