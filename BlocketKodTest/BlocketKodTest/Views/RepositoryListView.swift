import SwiftUI

struct RepositoryListView: View {
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [.gray, .gray.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: UIScreen.main.bounds.height * 0.15)
            .ignoresSafeArea(.all)
            .background(Color.black)
            
            VStack(spacing: 0) {
                HStack {
                    Text("GitHub OAuth 2.0 Demo")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        DataManager.shared.logout()
                    }) {
                        ZStack {
                            Rectangle()
                                .fill()
                                .foregroundColor(Color.gray.opacity(0.9))
                                .frame(width: 60, height: 34)
                                .cornerRadius(6)
                            Text("Logout")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    .padding(.trailing)
                }
                .padding(.top, 45)
              
                
                List {
                    ForEach(DataManager.shared.repositories) { repository in
                        RepositoryView(repository: repository)
                    }
                }
                .listStyle(.plain)
                .padding(.top, 1)
            }
            .ignoresSafeArea(.all)
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView()
    }
}
