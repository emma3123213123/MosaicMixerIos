//
//  EditarColorView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 11/05/25.
//

import SwiftUI

struct EditarColorView: View {
    @Environment(\.presentationMode) var presentationMode
    var color: ColorPiedra
    //var onSave: () -> Void  // ✅ Callback

    @State private var nombreColor: String
    @State private var precio: String
    @State private var imagenColor: UIImage?
    @State private var mostrarPicker = false
    @State private var mensajeError: String?
    @State private var mostrandoCargando = false
    @State private var mostrarAlerta = false
    
    init(color: ColorPiedra) {
        self.color = color
     //   self.onSave = onSave
        _nombreColor = State(initialValue: color.nombre)
        _precio = State(initialValue: color.precio)
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Editar Color de Piedra")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.white)

            ScrollView {
                VStack(spacing: 20) {
                    
                    if mostrandoCargando {
                        Text("Actualizando color...")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    campoDiseñado(titulo: "Nombre del color", texto: $nombreColor)
                    campoDiseñado(titulo: "Precio", texto: $precio)
                        .keyboardType(.decimalPad)

                    // Imagen
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Imagen del color")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if let imagen = imagenColor {
                            Image(uiImage: imagen)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .cornerRadius(12)
                        } else {
                            AsyncImage(url: URL(string: color.imagenURL)) { image in
                                image.resizable()
                                     .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: 180)
                            .cornerRadius(12)
                        }

                        Button(action: {
                            mostrarPicker = true
                        }) {
                            Text("Cambiar Imagen")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    Button(action: {
                        actualizarColor()
                    }) {
                        Text("Guardar Cambios")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)

                    if let mensajeError = mensajeError {
                        Text(mensajeError)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $mostrarPicker) {
            ImagePicker(image: $imagenColor)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .alert(isPresented: $mostrarAlerta) {
            Alert(title: Text("¡Éxito!"),
                  message: Text("Color actualizado correctamente."),
                  dismissButton: .default(Text("OK")) {
                      presentationMode.wrappedValue.dismiss()
                  })
            
        }
        
    }

    func actualizarColor() {
        guard let id = color.id else {
            mensajeError = "ID inválido."
            return
        }
        
        mostrandoCargando = true
        
        ColorManager.shared.actualizarColor(
            id: id,
            nuevoNombre: nombreColor,
            nuevoPrecio: precio,
            nuevaImagen: imagenColor,
            urlImagenAnterior: color.imagenURL
        ) { result in
            mostrandoCargando = false
            switch result {
            case .success():
                mostrarAlerta = true
            case .failure(let error):
                mensajeError = "Error: \(error.localizedDescription)"
            }
        }
    }
    
      func guardarCambios() {
          // Cuando termina de editar exitosamente:
        //  onSave() // ✅ Llama al callback para actualizar
      }
    
    @ViewBuilder
    func campoDiseñado(titulo: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField(titulo, text: texto)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
        
    }
    
}
    
