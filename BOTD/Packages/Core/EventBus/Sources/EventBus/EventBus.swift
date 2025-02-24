//
//  EventBus.swift
//  EventBus
//
//  Created by 정다은 on 2/23/25.
//

import Foundation
import RxSwift

@MainActor
public protocol EventBusProtocol {
    func asObservable() -> Observable<BOTDEvent>
    func publish(event: BOTDEvent)
}

public struct EventBus: EventBusProtocol {
    public static let shared = EventBus()
    private init() {   }
    
    private let subject = PublishSubject<BOTDEvent>()
    
    public func asObservable() -> Observable<BOTDEvent> {
        subject.observe(on: MainScheduler.instance).asObservable()
    }
    
    public func publish(event: BOTDEvent) {
        subject.on(.next(event))
    }
}

public enum BOTDEvent {
    case refreshHistories
}
