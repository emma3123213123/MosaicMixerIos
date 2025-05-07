import SwiftUI

struct RootViews: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            ClientMainTabView()
        } else {
            StartView()
        }
    }
}
