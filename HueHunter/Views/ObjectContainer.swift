//
//  ObjectContainer.swift
//  HueHunter
//
//  Created by Noura Sultan Ibn Qurmulah on 19/06/1444 AH.
//

import SwiftUI

struct ObjectContainer: View {
    let object: Object
    @ObservedObject var viewModel: GameViewModel
    private let regularSize: CGFloat = 100
    private let highlightedSize: CGFloat = 130
    
    var body: some View {
        ZStack{
            
            object.image
                .frame(width: regularSize, height: regularSize)
                .shadow(radius: 5)
            if viewModel.isHighlighted(id: object.id) {
                Circle()
                    .fill(object.color)
                    .opacity(0.5)
                    .frame(
                        width: highlightedSize,
                        height: highlightedSize
                    )
                
            }
        }
            .overlay {
                GeometryReader { proxy -> Color in
                    viewModel.update(
                        frame: proxy.frame(in: .global),
                        for: object.id
                    )
                    
                    return Color.clear
                }
            }
            .frame(width: highlightedSize, height: highlightedSize)
    }
}

struct ObjectContainer_Previews: PreviewProvider {
    static var previews: some View {
        ObjectContainer(
            object: Object.all.first!,
            viewModel: GameViewModel()
        )
    }
}
