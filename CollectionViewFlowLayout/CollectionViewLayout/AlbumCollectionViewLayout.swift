//
//  AlbumCollectionViewLayout.swift
//  Bloomr
//
//  Created by Tan Tan on 8/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

enum AlbumSegmentStyle {
    case oneItem
    case threeItems
    case fourItems
}

class AlbumCollectionViewLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    let padding: CGFloat = 2
    let numbColumn = 3
    
    var segment: AlbumSegmentStyle = .oneItem
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        // Remove cache
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)

        let count = collectionView.numberOfItems(inSection: 0)
        
        var yOffsets = [CGFloat](repeating: 0.0, count: numbColumn)

        let itemSize = collectionView.bounds.width  / CGFloat (numbColumn)
        
        var currentIndex = 0

        while currentIndex < count {
            var frame: CGRect = .zero

            switch segment {
            case .oneItem:
                if currentIndex < count {
                    let minY = yOffsets.min() ?? 0
                    let col = yOffsets.firstIndex(of: minY) ?? 0
                    
                    frame = CGRect(x: CGFloat(col) * itemSize, y: minY, width: collectionView.bounds.width, height: itemSize * 1.5).insetBy(dx: padding, dy: padding)
                    appendAttributes(frame: frame, for: currentIndex)
                    
                    yOffsets = [CGFloat](repeating: frame.maxY + padding, count: 3)
                    currentIndex += 1
                }
            case .threeItems:
                
                for _ in 0..<3 where currentIndex < count {
                    let minY = yOffsets.min() ?? 0
                    let col = yOffsets.firstIndex(of: minY) ?? 0
                    
                    frame = CGRect(x: CGFloat(col) * itemSize, y: minY, width: itemSize, height: itemSize).insetBy(dx: padding, dy: padding)
                    appendAttributes(frame: frame, for: currentIndex)
                    
                    yOffsets[col] = frame.maxY + padding
                    currentIndex += 1
                }

            case .fourItems:
                
                for i in 0..<4 where currentIndex < count {
                    let minY = yOffsets.min() ?? 0
                    let col = yOffsets.firstIndex(of: minY) ?? 0

                    if i == 1 {
                        frame = CGRect(x: CGFloat(col) * itemSize, y: minY, width: itemSize * 2, height: itemSize * 3).insetBy(dx: padding, dy: padding)
                        
                        yOffsets[col] = frame.maxY + padding
                        yOffsets[col+1] = frame.maxY + padding
                    } else {
                        frame = CGRect(x: CGFloat(col) * itemSize, y: minY, width: itemSize, height: itemSize).insetBy(dx: padding, dy: padding)
                        yOffsets[col] = frame.maxY + padding
                    }
                    
                    appendAttributes(frame: frame, for: currentIndex)
                    currentIndex += 1
                }
            }
            
            let remainItems = count - currentIndex
            switch remainItems {
            case 1 :
               segment = .oneItem
            case 2...3:
                segment = .threeItems
            default:
                switch segment {
                case .oneItem:
                    segment = .threeItems
                case .threeItems:
                    segment = .fourItems
                case .fourItems:
                    segment = .threeItems
                }
            }
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        // Find any cell that sits within the query rect.
        guard let lastIndex = cachedAttributes.indices.last,
            let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
        
        // Starting from the match, loop up and down through the array until all the attributes
        // have been added within the query rect.
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
}

extension AlbumCollectionViewLayout {
    
    func appendAttributes(frame: CGRect, for index: Int) {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
        attribute.frame = frame
        
        cachedAttributes.append(attribute)
        contentBounds = contentBounds.union(frame)
    }
    
    // Perform a binary search on the cached attributes array.
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }
}
