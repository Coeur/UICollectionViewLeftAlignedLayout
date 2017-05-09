
// Copyright (c) 2014 Giovanni Lodi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(withSectionInset sectionInset: UIEdgeInsets) {
        frame.origin.x = sectionInset.left
    }
}

/**
 *  Simple UICollectionViewFlowLayout that aligns the cells to the left rather than justify them
 *
 *  Based on http://stackoverflow.com/questions/13017257/how-do-you-determine-spacing-between-cells-in-uicollectionview-flowlayout
 */
open class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originalAttributes = super.layoutAttributesForElements(in: rect)
        var updatedAttributes = originalAttributes
        for attributes in originalAttributes ?? [] where attributes.representedElementKind == nil {
            let index = updatedAttributes!.index(of: attributes)!
            updatedAttributes![index] = layoutAttributesForItem(at: attributes.indexPath)!
        }
        return updatedAttributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        guard let collectionView = self.collectionView else {
            return currentItemAttributes
        }
        
        let sectionInset = evaluatedSectionInsetForSection(at: indexPath.section)
        
        guard indexPath.item != 0 else {
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        guard let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame else {
            return currentItemAttributes
        }
        
        let layoutWidth = collectionView.frame.width - sectionInset.left - sectionInset.right
        
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // widht intersects the previous frame then they are on the same line
        guard previousFrame.intersects(CGRect(x: sectionInset.left, y: currentItemAttributes.frame.origin.y, width: layoutWidth, height: currentItemAttributes.frame.size.height)) else {
            // make sure the first item on a line is left aligned
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        currentItemAttributes.frame.origin.x = previousFrame.origin.x + previousFrame.size.width + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
        return currentItemAttributes
    }
    
    func evaluatedMinimumInteritemSpacingForSection(at section: NSInteger) -> CGFloat {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    func evaluatedSectionInsetForSection(at index: NSInteger) -> UIEdgeInsets {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, insetForSectionAt: index) ?? sectionInset
    }
}
