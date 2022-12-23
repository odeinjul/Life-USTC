//
//  FeedSourceModel.swift
//  Life@USTC (iOS)
//
//  Created by TiankaiMa on 2022/12/22.
//

import SwiftUI
import FeedKit

enum FeedSourceType: Codable {
    case rss
    case json
}

enum AsyncViewStatus {
    case inProgress
    case success
    case failure
}

protocol FeedSource {
    var type: FeedSourceType { get }
    var name: String { get }
    var id: UUID { get }
    var description: String? { get }
    var image: String? { get }
    
    func fetchRecentPost() async throws -> [FeedPost] // this could be loaded from local storage
    func forceUpdatePost() async throws -> [FeedPost] // this requires a network request
    func updateRequest()
    
    func fetchRecentPost(posts: Binding<[FeedPost]>, status: Binding<AsyncViewStatus>)
    func forceUpdatePost(posts: Binding<[FeedPost]>, status: Binding<AsyncViewStatus>)
}

var feedSourceList: [FeedSource] = defaultFeedSources // all new sources should be added to this list

struct RSSFeedSource: FeedSource {
    var type: FeedSourceType = .rss
    
    var url: URL
    var name: String
    var id = UUID()
    
    var description: String?
    var image: String?
    
    var cache: FeedPostCache? {
        postCacheList.first(where: {$0.id == self.id})
    }
    
    var parser: FeedParser
    
    func fetchRecentPost() async throws -> [FeedPost] {
        // MARK: sorry for making completely non-sense here, gonna re-write it after I make sure I've got a clear mind...
        if cache != nil && !cache!.posts.isEmpty {
            guard let cache = cache else { return [] }
            if cache.lastUpdated.addingTimeInterval(7200) > Date() {
                return cache.posts
            } else {
                let data = try await self.forceUpdatePost()
                postCacheList.removeAll(where: {$0.id == self.id})
                postCacheList.append(FeedPostCache(lastUpdated: Date(), posts: data, id: self.id))
                return data
            }
        } else {
            let data = try await self.forceUpdatePost()
            return data
        }
    }
    
    func forceUpdatePost() async throws -> [FeedPost]  {
        debugPrint("!!! Refresh \(self.name) RSSFeedPost")
        let result = parser.parse()
        switch result {
        case .success(let feed):
            let data: [FeedPost] = feed.rssFeed?.items?.map {FeedPost(item: $0, source: self.name)} ?? []
            // this means the feed is updated, so we need to update the cache
            // logic problem here, remove the old cache and add the new one
            postCacheList.removeAll(where: {$0.id == self.id})
            postCacheList.append(FeedPostCache(lastUpdated: Date(), posts: data, id: self.id))
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func fetchRecentPost(posts: Binding<[FeedPost]>, status: Binding<AsyncViewStatus>) {
        _ = Task {
            do {
                posts.wrappedValue = try await fetchRecentPost()
                status.wrappedValue = .success
            } catch {
                status.wrappedValue = .failure
                print(error)
            }
        }
    }
    
    func forceUpdatePost(posts: Binding<[FeedPost]>, status: Binding<AsyncViewStatus>) {
        _ = Task {
            do {
                posts.wrappedValue = try await forceUpdatePost()
                status.wrappedValue = .success
            } catch {
                status.wrappedValue = .failure
                print(error)
            }
        }
    }
    
    
    func updateRequest() {
        _ = Task {
            do {
                _ = try await forceUpdatePost()
            } catch {
                print(error)
            }
        }
    }
    
    init(url: URL, name: String, id: UUID = UUID(), description: String? = nil, image: String? = nil, flag: Bool = false) {
        self.url = url
        self.name = name
        self.id = id
        
        self.description = description
        self.image = image
        self.parser = FeedParser(URL: self.url)
        
        // add to the feedSourceList
        if flag {
            feedSourceList.append(self)
        }
    }
}
