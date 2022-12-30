//
//  FeedConstants.swift
//  Life@USTC (iOS)
//
//  Created by TiankaiMa on 2022/12/22.
//

import Foundation

let ustcHomePageFeedURL = URL(string: "https://www.ustc.edu.cn/system/resource/code/rss/rssfeedg.jsp?type=list&treeid=1002&viewid=249541&mode=10&dbname=vsb&owner=1585251974&ownername=zz&contentid=221571,221572,221573,221574&number=100&httproot=")!
let ustcOAAFeedURL = URL(string: "https://www.teach.ustc.edu.cn/category/notice/feed")!

let defaultFeedSources = [RSSFeedSource(url: ustcOAAFeedURL, name: "教务处", id: fixedUUIDList[0], image: "person.crop.square.fill.and.at.rectangle"),
                          RSSFeedSource(url: ustcHomePageFeedURL, name: "校主页", id: fixedUUIDList[1], image: "icloud.square.fill")]
