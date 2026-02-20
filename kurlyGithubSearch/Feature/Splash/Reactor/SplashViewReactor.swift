//
//  SplashViewReactor.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import ReactorKit
import RxSwift
import UIKit

final class SplashViewReactor: Reactor {

    enum Action {
        case startAnimation
    }

    enum Mutation {
        case fadeInAppName 
        case moveToSearch // 뷰 이동
    }

    struct State {
        var appNameAlpha: CGFloat = 0
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startAnimation: // 2.5초 후 화면전환
            let fadeInAppName = Observable<Mutation>.just(.fadeInAppName).delay(.milliseconds(100), scheduler: MainScheduler.instance)
            let moveToSearch = Observable<Mutation>.just(.moveToSearch).delay(.milliseconds(2500), scheduler: MainScheduler.instance)
            return Observable.concat([fadeInAppName, moveToSearch])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fadeInAppName:
            newState.appNameAlpha = 1
        case .moveToSearch:
            break
        }
        return newState
    }
}

