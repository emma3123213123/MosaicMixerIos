import SwiftUI

struct ColorInfo: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
    let price: String

    // Comparamos por name para evitar duplicados
    static func == (lhs: ColorInfo, rhs: ColorInfo) -> Bool {
        return lhs.name == rhs.name
    }
}

struct ColorSelectionSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedColors: [ColorInfo]
    @State private var searchText = ""

    // Lista completa de colores
    let allColors: [ColorInfo] = [
        ColorInfo(name: "Brecia Vino", imageName: "breciavino", price: "$250"),
        ColorInfo(name: "Carrara", imageName: "carrar", price: "$300"),
        ColorInfo(name: "Nero", imageName: "nero", price: "$270"),
        ColorInfo(name: "Orange", imageName: "orange", price: "$270")
    ]

    var body: some View {
        // Filtro: no repetidos + búsqueda
        let filteredColors = allColors.filter { color in
            !selectedColors.contains(where: { $0.name == color.name }) &&
            (searchText.isEmpty || color.name.localizedCaseInsensitiveContains(searchText))
        }

        VStack(alignment: .leading, spacing: 12) {
            Text("Colores")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.top)
                .multilineTextAlignment(.center)

            // Barra de búsqueda
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Buscar color...", text: $searchText)
                    .foregroundColor(.black)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .cornerRadius(12)
            .padding(.horizontal)

            // Lista de colores filtrados
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(filteredColors) { color in
                        VStack(alignment: .leading, spacing: 6) {
                            Divider().background(Color.gray.opacity(0.5))

                            Text(color.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.black)

                            HStack {
                                Image(color.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 100)
                                    .cornerRadius(8)

                                Spacer()

                                Text(color.price)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .onTapGesture {
                                selectedColors.append(color)
                                isPresented = false
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .padding(.top)
        .background(Color.white)
    }
}
