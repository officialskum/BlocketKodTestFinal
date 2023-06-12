import Foundation

class RepositoryViewModel: ObservableObject {
    let dataManager: DataManagerProtocol = DataManager.shared
}
