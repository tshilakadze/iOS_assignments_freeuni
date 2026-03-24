//
//  CustomCollectionLayout.swift
//  notes-app
//
//  Created by Tsotne Shilakadze on 18.01.26.
//



import UIKit

protocol CustomLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForItemAt indexPath: IndexPath,
        with width: CGFloat
    ) -> CGFloat
}

import UIKit

class CustomLayout: UICollectionViewLayout {
    
    weak var delegate: CustomLayoutDelegate?
    
    private let numberOfColumns = 2
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    private lazy var columnSpacing = screenWidth * 0.02
    private lazy var rowSpacing = screenHeight * 0.015
    private lazy var contentInset = screenWidth * 0.01
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    override func prepare() {
        guard
            cache.isEmpty,
            let collectionView = collectionView,
            let delegate = delegate
        else { return }
        
        let totalSpacing = contentInset * 2 + columnSpacing
        let columnWidth = (contentWidth - totalSpacing) / CGFloat(numberOfColumns)
        
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(
                contentInset + CGFloat(column) * (columnWidth + columnSpacing)
            )
        }
        
        var yOffset = Array(repeating: CGFloat(0), count: numberOfColumns)
        var column = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let height = delegate.collectionView(
                collectionView,
                heightForItemAt: indexPath,
                with: columnWidth
            )
            
            let frame = CGRect(
                x: xOffset[column],
                y: yOffset[column],
                width: columnWidth,
                height: height
            )
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += height + rowSpacing
            
            column = column < (numberOfColumns - 1) ? column + 1 : 0
        }
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes] {
        cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        cache.first { $0.indexPath == indexPath }
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        contentHeight = 0
    }
}
