import SwiftUI
import RealityKit

struct MosaicoResumenView: View {
    let mosaico: Mosaico
    let selectedColors: [ColorInfo]
    
    @State private var metrosCuadrados: String = ""
    @State private var cajas: String = ""

    // MARK: - Cálculos de conversión y precios

    private func convertirDesdeMetros(_ metros: String) {
        if let valor = Double(metros) {
            cajas = String(format: "%.0f", valor) // 1 m² = 1 caja
        } else {
            cajas = ""
        }
    }

    private func convertirDesdeCajas(_ cantidad: String) {
        if let valor = Double(cantidad) {
            metrosCuadrados = String(format: "%.0f", valor)
        } else {
            metrosCuadrados = ""
        }
    }

    private func precioMosaicoPorM2() -> Double {
        Double(mosaico.precio.replacingOccurrences(of: "$", with: "")) ?? 0
    }

    private func precioPorMetros() -> Double {
        guard let metros = Double(metrosCuadrados) else { return 0 }
        return metros * precioMosaicoPorM2()
    }

    private func subtotalColores() -> Double {
        selectedColors
            .compactMap { Double($0.price.replacingOccurrences(of: "$", with: "")) }
            .reduce(0, +)
    }

    private func totalFinal() -> Double {
        return precioPorMetros() + subtotalColores()
    }

    // MARK: - Propiedades auxiliares para performance del compilador

    var costoM2: Double {
        precioMosaicoPorM2()
    }

    var costoTotalMosaico: Double {
        precioPorMetros()
    }

    var costoColores: Double {
        subtotalColores()
    }

    var costoFinal: Double {
        totalFinal()
    }

    // MARK: - Vista principal

    var body: some View {
        VStack(spacing: 0) {
            // Encabezado
            HStack {
                Spacer()
                Text(mosaico.nombre)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.vertical, 10)
            .background(Color.white)
            
            ScrollView {
                VStack(spacing: 20) {
                    // AR Preview
                    ARViewContainer(selectedColors: selectedColors, modelName: mosaico.nombre)
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding(.horizontal)

                    Divider()

                    // Títulos
                    HStack {
                        Text("Colores")
                            .font(.subheadline).bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Descripción")
                            .font(.subheadline).bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Precio")
                            .font(.subheadline).bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)

                    Divider()

                    // Lista de colores
                    ForEach(selectedColors, id: \.id) { color in
                        HStack {
                            Image(color.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 60)
                                .cornerRadius(6)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            VStack {
                                Text("Color")
                                    .font(.caption)
                                    .foregroundColor(.black)
                                Text(color.name)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)

                            Text(color.price)
                                .font(.caption)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal)
                    }

                    Divider().padding(.top)
                    
                    // Conversión m² <-> cajas
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("m²")
                                .font(.caption)
                                .foregroundColor(.black)

                            TextField("Ingresa m²", text: $metrosCuadrados)
                                .keyboardType(.decimalPad)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .onChange(of: metrosCuadrados) { newValue in
                                    convertirDesdeMetros(newValue)
                                }
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("OK") {
                                            hideKeyboard()
                                        }
                                    }
                                }
                        }

                        Image(systemName: "arrow.left.arrow.right")
                            .font(.title2)
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cajas")
                                .font(.caption)
                                .foregroundColor(.black)

                            TextField("Ingresa cajas", text: $cajas)
                                .keyboardType(.decimalPad)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .onChange(of: cajas) { newValue in
                                    convertirDesdeCajas(newValue)
                                }
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("OK") {
                                            hideKeyboard()
                                        }
                                    }
                                }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // Resumen de precios
                    VStack(spacing: 8) {
                        HStack {
                            Text("Precio Unidad")
                                .foregroundColor(.black)
                            Spacer()
                            Text("$\(costoM2, specifier: "%.2f")")
                                .foregroundColor(.black)
                        }

                        HStack {
                            Text("Precio Total m²")
                                .foregroundColor(.black)
                            Spacer()
                            Text("$\(costoTotalMosaico, specifier: "%.2f")")
                                .foregroundColor(.black)
                        }

                        HStack {
                            Text("Precio Colores")
                                .foregroundColor(.black)
                            Spacer()
                            Text("$\(costoColores, specifier: "%.2f")")
                                .foregroundColor(.black)
                        }

                        Divider()

                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Spacer()
                            Text("$\(costoFinal, specifier: "%.2f")")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
            }

            // Bottom navigation
            HStack {
                Spacer()
                Image(systemName: "cart")
                Spacer()
                NavigationLink(destination: FavoritosView()) {
                Image(systemName: "heart")
                };                Spacer()
                Image(systemName: "house")
                Spacer()
                Image(systemName: "bell")
                Spacer()
                Image(systemName: "person")
                Spacer()
            }
            .foregroundColor(.white)
            .font(.system(size: 25))
            .padding(25)
            .background(Color.black)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
