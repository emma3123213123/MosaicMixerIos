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
        ColorInfo(name: "Argento", imageName: "Argento", price: "$250"),
        ColorInfo(name: "Ash", imageName: "Ash", price: "$300"),
        ColorInfo(name: "Basalt", imageName: "Basalt", price: "$270"),
        ColorInfo(name: "Bianco", imageName: "Bianco", price: "$270"),
        ColorInfo(name: "Birch", imageName: "Birch", price: "$270"),
        ColorInfo(name: "Breccia Azul", imageName: "Breccia Azul", price: "$270"),
        ColorInfo(name: "Breccia Fiore", imageName: "Breccia Fiore", price: "$270"),
        ColorInfo(name: "Breccia Nero", imageName: "Breccia Nero", price: "$270"),
        ColorInfo(name: "Breccia Nuvole", imageName: "Breccia Nuvole", price: "$270"),
        ColorInfo(name: "Calaglio", imageName: "Calaglio", price: "$270"),
        ColorInfo(name: "Carmel", imageName: "Carmel", price: "$270"),
        ColorInfo(name: "Carrara", imageName: "Carrara", price: "$270"),
        ColorInfo(name: "Cedar", imageName: "Cedar", price: "$270"),
        ColorInfo(name: "Charcoal", imageName: "Charcoal", price: "$270"),
        ColorInfo(name: "Cream", imageName: "Cream", price: "$270"),
        ColorInfo(name: "Danby", imageName: "Danby", price: "$270"),
        ColorInfo(name: "Date", imageName: "Date", price: "$270"),
        ColorInfo(name: "Dourdan", imageName: "Dourdan", price: "$270"),
        ColorInfo(name: "Fig", imageName: "Fig", price: "$270"),
        ColorInfo(name: "Grigio", imageName: "Grigio", price: "$270"),
        ColorInfo(name: "Latte VC", imageName: "Latte VC", price: "$270"),
        ColorInfo(name: "Latte", imageName: "Latte", price: "$270"),
        ColorInfo(name: "Maderno", imageName: "Maderno", price: "$270"),
        ColorInfo(name: "Menorca", imageName: "Menorca", price: "$270"),
        ColorInfo(name: "Montclair", imageName: "Montclair", price: "$270"),
        ColorInfo(name: "Nero", imageName: "Nero", price: "$270"),
        ColorInfo(name: "Orange", imageName: "Orange", price: "$270"),
        ColorInfo(name: "Pearl", imageName: "Pearl", price: "$270"),
        ColorInfo(name: "Pecan", imageName: "Pecan", price: "$270"),
        ColorInfo(name: "Pepper", imageName: "Pepper", price: "$270"),
        ColorInfo(name: "Pewter", imageName: "Pewter", price: "$270"),
        ColorInfo(name: "Primavera", imageName: "Primavera", price: "$270"),
        ColorInfo(name: "Riviera Beige", imageName: "Riviera Beige", price: "$270"),
        ColorInfo(name: "Royal", imageName: "Royal", price: "$270"),
        ColorInfo(name: "Sable", imageName: "Sable", price: "$270"),
        ColorInfo(name: "Savena", imageName: "Savena", price: "$270"),
        ColorInfo(name: "Sedona", imageName: "Sedona", price: "$270"),
        ColorInfo(name: "Seville", imageName: "Seville", price: "$270"),
        ColorInfo(name: "Siena", imageName: "Siena", price: "$270"),
        ColorInfo(name: "Vintage VC", imageName: "Vintage VC", price: "$270"),
        ColorInfo(name: "Vintage", imageName: "Vintage", price: "$270"),
        ColorInfo(name: "White", imageName: "White", price: "$270")
        

        
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
