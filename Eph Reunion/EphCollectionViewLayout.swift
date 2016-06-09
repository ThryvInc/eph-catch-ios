//
//  EphCollectionViewLayout.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/12/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class EphCollectionViewLayout: UICollectionViewFlowLayout {
    var numberOfColumns = 2
    var cellPadding: CGFloat = 2.0
    
    //3. Array to keep a cache of attributes.
    private var cache = [UICollectionViewLayoutAttributes]()
    
    //4. Content height and size
    private var contentHeight:CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return UICollectionViewLayoutAttributes.self
    }
    
    override func prepareLayout() {
        // 1. Only calculate once
        if cache.isEmpty {
            
            // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            // 3. Iterates through the list of items in the first section
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                if item == 0 {
                    let width = columnWidth - 2 * cellPadding
                    let hintHeight:CGFloat = heightForHint(UIFont.systemFontOfSize(17), width: width - 2 * 32)
                    let height = cellPadding +  hintHeight + cellPadding
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: width, height: height)
                    let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                    
                    // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    
                    // 6. Updates the collection view content height
                    contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                    yOffset[column] = yOffset[column] + height
                }else{
                    let width = columnWidth - 2 * cellPadding
                    let photoHeight:CGFloat = 200.0
                    let height = cellPadding +  photoHeight + cellPadding
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: width, height: height)
                    let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                    
                    // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    
                    // 6. Updates the collection view content height
                    contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                    yOffset[column] = yOffset[column] + height
                }
                
                column = column >= (numberOfColumns - 1) ? 0 : column+1
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes  in cache {
            if CGRectIntersectsRect(attributes.frame, rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    func heightForHint(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = "Long press to let them know you want to catch up!".boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
