//
//  GrupoSectionView.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 26/04/25.
//

import SwiftUI

struct GrupoSectionView: View {
    let nombre: String
    let mosaicos: [Mosaico]

    var body: some View {
        VStack(alignment: .leading) {
            Text(nombre)
                .font(.title3.bold())
                .foregroundColor(.black)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(mosaicos) { mosaico in
                        GeometryReader { geo in
                            let scale = getScale(geo: geo)
                            NavigationLink(destination: MosaicoDetailView(mosaico: mosaico)) {
                                MosaicoCardView(mosaico: mosaico, scale: scale)
                            }
                            .buttonStyle(PlainButtonStyle()) // Para evitar que cambie estilo
                        }
                        .frame(width: 180, height: 260)
                    }
                }
                .padding(.horizontal)
            }

            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.4)) // color con opacidad
                    .frame(height: 2)              // grosor de la línea
                    .cornerRadius(2)
            }
            .padding(.horizontal, 30)
            .padding(.top)
        }
    }

    func getScale(geo: GeometryProxy) -> CGFloat {
        let midX = geo.frame(in: .global).midX
        let screenMid = UIScreen.main.bounds.width / 2
        let diff = abs(screenMid - midX)
        return max(1 - (diff / screenMid) * 0.2, 0.85)
    }
}
