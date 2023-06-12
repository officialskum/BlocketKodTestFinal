import SwiftUI

struct RepositoryView: View {
    let repository: Repository
    @State private var isFavorite = false
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            Divider()
            if isExpanded {
                expandedView
                    .transition(.slide)
            }
            footerView
        }
        .background(Color.white)
        .cornerRadius(8)
        .padding()
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AsyncImage(url: URL(string: repository.owner.avatar_url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .padding(.leading, 20)
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .padding(.leading, 20)
                }
                
                Spacer()
                
                Text(repository.name)
                    .font(.headline)
                    .padding(.vertical, 8)
                    .frame(width: 300)
                    
                    .foregroundColor(.white)
            }
            .background(Color.gray)
            
            Text("Created: \(formatter)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
    }
    
    private var expandedView: some View {
        VStack(alignment: .leading) {
            Text(repository.description ?? "No description available.")
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
        }
        .transition(.opacity)
    }
    
    private var footerView: some View {
        HStack {
            Spacer()
            
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundColor(.yellow)
                .onTapGesture {
                    isFavorite.toggle()
                }
            
            Image(systemName: "plus")
                .foregroundColor(.gray)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
    
    private var formatter: String {
        let dateString = repository.created_at
        let modifiedDateString = dateString.replacingOccurrences(of: "Z", with: "")
        return modifiedDateString
    }
    
    struct RepositoryView_Previews: PreviewProvider {
        static var previews: some View {
            let owner = Repository.Owner(login: "John Doe",
                                         avatar_url: "https://example.com/avatar")
            
            let repository = Repository(
                id: 1,
                name: "Cool Repository",
                created_at: "Thu 8 June",
                description: "A sample repository",
                owner: owner
            )
            
            return RepositoryView(repository: repository)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}

