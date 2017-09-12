//
//  core.swift
//  linkedAccounts
//
//  Created by Oleksandr on 9/12/17.
//  Copyright © 2017 Sanek Hackathon. All rights reserved.
//

import Foundation

protocol PrintMe {
    func printMe()
}

struct AccountIndex: PrintMe {
    let accountId: String
    var prevId: String?
    var nextId: String?

    func printMe() {
        print("Account index: id = \(accountId), prevId = \(prevId ?? "--"), nexId = \(nextId ?? "--")")
    }
}

struct Tweet {
    let tweetId: String
    var isActive: Bool

    init(tweetId: String = UUID().uuidString, isActive: Bool = true) {
        self.tweetId = tweetId
        self.isActive = isActive
    }
}

struct Account: PrintMe {
    let accountId: String
    var tweets = [Tweet]() {
        didSet {
            self.activeTweetCount = self.tweets.filter { $0.isActive == true }.count
        }
    }
    private(set) var activeTweetCount = 0

    mutating func deactivateTweet(withId tweetId: String) {
        for index in 0 ..< self.tweets.count where self.tweets[index].tweetId == tweetId {
            self.tweets[index].isActive = false
            self.activeTweetCount -= 1
            break
        }
    }

    mutating func deactivateSomeTweet() {
        guard self.activeTweetCount > 0 else { return }
        for index in 0 ..< self.tweets.count where self.tweets[index].isActive == true {
            self.tweets[index].isActive = false
            self.activeTweetCount -= 1
            break
        }
    }

    init(accountId: String = UUID().uuidString) {
        self.accountId = accountId
    }

    func printMe() {
        print("Account: id = \(accountId), cont of tweets = \(tweets.count), active = \(activeTweetCount)")
    }

}

func create10baseAccounts() {
    var tweets = [Tweet]()
    var account: Account
    var accountIndex: AccountIndex
    var tweet: Tweet

    var listsCount = 0

    for index in 0 ..< 10 {
        tweets.removeAll()
        for _ in 0 ..< arc4random_uniform(10) {
            tweet = Tweet(isActive: true)
            tweets.append(tweet)
        }

        listsCount = accountsBaseList.count

        account = Account(accountId: String(index))
//        account = Account()
        account.tweets = tweets

        accountIndex = AccountIndex(accountId: account.accountId,
                                    prevId: listsCount > 0 ? accountIndexesList[listsCount - 1].accountId : nil,
                                    nextId: nil)

        if listsCount > 0 {
            accountIndexesList[listsCount - 1].nextId = account.accountId
        }

        accountsBaseList.append(account)
        accountIndexesList.append(accountIndex)

    }
}

func readAllTweetsOneByOneFromAccount(withId accountId: String) {
    guard let index = accountsBaseList.index(where: { account -> Bool in
        account.accountId == accountId
    }) else { return }

    while accountsBaseList[index].activeTweetCount > 0 {
        accountsBaseList[index].deactivateSomeTweet()
    }
}

func createOtherBaseRandomAccountsList(number: Int) -> [Account] {
    var accountsList = [Account]()

    for _ in 0 ..< number {
        let newId = Int(arc4random_uniform(20))

        var countOfTweets = Int(arc4random_uniform(30)) - 15
        countOfTweets = countOfTweets < 0 ? 0 : countOfTweets

        // count of tweets sholdn't be less then they already are in base
        if let indexFromBase = accountsBaseList.index(where: { account -> Bool in
            account.accountId == String(newId)
        }) {
            countOfTweets = countOfTweets < accountsBaseList[indexFromBase].tweets.count ?
                                            accountsBaseList[indexFromBase].tweets.count : countOfTweets
        }

        var tweets = [Tweet]()
        for _ in 0 ..< countOfTweets {
            let tweet = Tweet(isActive: arc4random_uniform(2) == 1 ? true : false)
            tweets.append(tweet)
        }

        var account = Account(accountId: String(newId))
        account.tweets = tweets
        accountsList.append(account)
    }

    return accountsList

}

func mergeBaseWith(accountList: [Account], forceDeleteRows: Bool = false) {

}

func print<T>(array: [T]) where T: PrintMe {
    array.forEach{ $0.printMe() }
}

var accountIndexesList = [AccountIndex]()
var accountsBaseList = [Account]()








