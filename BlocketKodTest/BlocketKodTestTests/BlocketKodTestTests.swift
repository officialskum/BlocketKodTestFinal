import XCTest
@testable import BlocketKodTest

final class BlocketKodTestTests: XCTestCase {
    var repositories: [Repository] = []
    var dataManager = DataManager()
    
    func setup() {
        dataManager = DataManager(authenticatedUser: "testUser")
    }
    
    override func tearDown() {
        
    }
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testIfRepositoriesFillProperly() {
        let repository = Repository(id: 1, name: "Sample Repository", created_at: "2023-06-11T12:34:56Z", description: "Test sample", owner: Repository.Owner(login: "sampleOwner", avatar_url: "https://example.com/avatar"))
        
        repositories = [repository]
        
        dataManager.loadingState = .successful
    }
    
    func testFetchAndFillRepositories() {
            XCTAssertEqual(dataManager.loadingState, .idle, "loadingState should be idle initially")
            XCTAssertTrue(repositories.isEmpty, "repositories array should be empty initially")
            
            testIfRepositoriesFillProperly()
            
            XCTAssertEqual(dataManager.loadingState, .successful, "loadingState should be successful after fetching repositories")
            XCTAssertEqual(repositories.count, 1, "repositories array should contain one repository")
            
            XCTAssertEqual(repositories.first?.id, 1, "The repository ID should match the expected value")
            XCTAssertEqual(repositories.first?.name, "Sample Repository", "The repository name should match the expected value")
        }
    
    // Testar att appen sätter state på rätt sätt mellan funktionsanrop
    // Skulle behöva mocka ut en instans av DataManager så man slipper göra nätverksanrop inuti testerna

    func testAuthorizeWithOAuth() {
        let manager = DataManager(authenticatedUser: "testUser")
        
        XCTAssertEqual(manager.loadingState, .idle, "loadingState should be idle initially")
        
        manager.authorizeWithOAuth()
        
        let expectation = XCTestExpectation(description: "Authorization completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(manager.loadingState, .loading, "loadingState should be loading after authorization")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testFetchRepositories() {
        let manager = DataManager(authenticatedUser: "testUser")
        
        XCTAssertEqual(manager.loadingState, .idle, "loadingState should be idle initially")
        
        manager.fetchRepositories()
       
        let expectation = XCTestExpectation(description: "Repositories fetched")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(manager.loadingState, .loading, "loadingState should be loading after fetching repositories")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testLogout() {
        
        let manager = DataManager(authenticatedUser: "testUser")
        
        manager.loadingState = .idle
        
        manager.logout()
        
        let loadingStateExpectation = XCTestExpectation(description: "Loading state transition")
        
        // Väntar i 2 sekunder så logout är avklarat
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(manager.loadingState, .idle, "loadingState should be idle after logout")
            
            XCTAssertEqual(manager.authenticatedUser, "", "authenticatedUser should be empty after logout")
            
            XCTAssertTrue(manager.repositories.isEmpty, "repositories should be empty after logout")
            
            loadingStateExpectation.fulfill()
        }
        wait(for: [loadingStateExpectation], timeout: 3)
    }
}




