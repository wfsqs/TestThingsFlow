import Foundation

import ReactorKit

final class IssueDetailReactor: Reactor {
    typealias Action = NoAction
    
    typealias Mutation = NoMutation
    
    struct State {
        var issue: Issue?
    }
    
    var initialState: State
    
    init(
        initialState: State
    ) {
        self.initialState = initialState
    }
}
