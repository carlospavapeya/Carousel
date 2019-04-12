//
//  Carousel.swift
//  Repository
//
//  Created by Carlos Pava on 4/12/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import UIKit

protocol CarouselCollectionViewProtocol {
    func updatePage(page:Int)
}


class CarouselCollectionView: UICollectionView {
    
    // MARK: - Properties (Private)
    
    private var lastCurrentCenterCellIndex: IndexPath?
    
    var delegateCorousel:CarouselCollectionViewProtocol?
    // MARK: - Properties (Public)
    
    /// Inset of the main, center cell
    @IBInspectable public var inset: CGFloat = 0.0 {
        didSet {
            /*
             Configure our layout, and add more
             constraints to our invisible UIScrollView
             */
            configureLayout()
        }
    }
    
    /// Returns the current center cell of the carousel if it can be calculated
    open var currentCenterCell: UICollectionViewCell? {
        
        let lowerBound = inset - 20
        let upperBound = inset + 20
        
        for cell in visibleCells {
            
            let cellRect = convert(cell.frame, to: nil)
            
            if cellRect.origin.x > lowerBound && cellRect.origin.x < upperBound {
                return cell
            }
            
        }
        
        return nil
    }
    
    /// Returns the IndexPath of the current center cell if it can be calculated
    open var currentCenterCellIndex: IndexPath? {
        guard let currentCenterCell = self.currentCenterCell else { return nil }
        
        return indexPath(for: currentCenterCell)
    }
    
    /// Override of the collection view content size to add an observer
    override open var contentSize: CGSize {
        didSet {
            
            guard let dataSource = dataSource,
                let invisibleScrollView = invisibleScrollView else { return }
            
            let numberSections = dataSource.numberOfSections?(in: self) ?? 1
            
            // Calculate total number of items in collection view
            var numberItems = 0
            
            for i in 0..<numberSections {
                
                let numberSectionItems = dataSource.collectionView(self, numberOfItemsInSection: i)
                numberItems += numberSectionItems
            }
            
            // Set the invisibleScrollView contentSize width based on number of items
            let contentWidth = invisibleScrollView.frame.width * CGFloat(numberItems)
            invisibleScrollView.contentSize = CGSize(width: contentWidth, height: invisibleScrollView.frame.height)
        }
    }
    
    // MARK: - Properties (Private)
    fileprivate var invisibleScrollView: UIScrollView!
    fileprivate var invisibleWidthConstraint: NSLayoutConstraint?
    fileprivate var invisibleLeftConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Convenience initializer allowing setting of the carousel inset
    ///
    /// - Parameters:
    ///   - frame: Frame
    ///   - inset: Inset
    public convenience init(withFrame frame: CGRect, andInset inset: CGFloat) {
        self.init(frame: frame, collectionViewLayout: CarouselLayout(withCarouselInset: inset))
        
        self.inset = inset
    }
    
    // MARK: - Overrides
    
    override open func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        invisibleScrollView.setContentOffset(rect.origin, animated: animated)
    }
    
    override open func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
        let originX = (CGFloat(indexPath.item) * (frame.size.width - (inset * 2)))
        let rect = CGRect(x: originX, y: 0, width: frame.size.width - (inset * 2), height: frame.height)
        scrollRectToVisible(rect, animated: animated)
        lastCurrentCenterCellIndex = indexPath
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addInvisibleScrollView(to: superview)
    }
    
    // MARK: - Public API
    
    /*
     This method should ALWAYS be called from the ScalingCarousel delegate when
     the UIScrollViewDelegate scrollViewDidScroll(_:) method is called
     
     e.g In the ScalingCarousel delegate, implement:
     
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
     carousel.didScroll()
     }
     */
    public func didScroll() {
        scrollViewDidScroll(self)
    }
    
    /*
     This method should ALWAYS be called from the ViewController that handles the ScalingCarousel when
     the viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) method is called
     
     e.g Implement:
     
     func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
     super.viewWillTransition(to: size, with: coordinator)
     carousel.deviceRotated()
     }
     */
    public func deviceRotated() {
        guard let lastCurrentCenterCellIndex = currentCenterCellIndex ?? lastCurrentCenterCellIndex else { return }
        DispatchQueue.main.async {
            self.reloadData()
            self.scrollToItem(at: lastCurrentCenterCellIndex, at: .centeredHorizontally, animated: false)
            self.didScroll()
        }
    }
}

extension CarouselCollectionView {
    
    fileprivate func addInvisibleScrollView(to superview: UIView?) {
        guard let superview = superview else { return }
        
        /// Add our 'invisible' scrollview
        invisibleScrollView = UIScrollView(frame: bounds)
        invisibleScrollView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrollView.isPagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        
        /*
         Disable user interaction on the 'invisible' scrollview,
         This means touch events will fall through to the underlying UICollectionView
         */
        invisibleScrollView.isUserInteractionEnabled = false
        
        /// Set the scroll delegate to be the ScalingCarouselView
        invisibleScrollView.delegate = self
        
        /*
         Now add the invisible scrollview's pan
         gesture recognizer to the ScalingCarouselView
         */
        addGestureRecognizer(invisibleScrollView.panGestureRecognizer)
        
        /*
         Finally, add the 'invisible' scrollview as a subview
         of the ScalingCarousel's superview
         */
        superview.addSubview(invisibleScrollView)
        
        /*
         Add constraints for height and top, relative to the
         ScalingCarouselView
         */
        invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        invisibleScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        /*
         Further configure our layout and add more constraints
         for width and left position
         */
        configureLayout()
    }
    
    fileprivate func configureLayout() {
        
        // Create a ScalingCarouselLayout using our inset
        collectionViewLayout = CarouselLayout(
            withCarouselInset: inset)
        
        /*
         Only continue if we have a reference to
         our 'invisible' UIScrollView
         */
        guard let invisibleScrollView = invisibleScrollView else { return }
        
        // Remove constraints if they already exist
        invisibleWidthConstraint?.isActive = false
        invisibleLeftConstraint?.isActive = false
        
        /*
         Add constrants for width and left postion
         to our 'invisible' UIScrollView
         */
        invisibleWidthConstraint = invisibleScrollView.widthAnchor.constraint(
            equalTo: widthAnchor, constant: -(2 * inset))
        invisibleLeftConstraint =  invisibleScrollView.leftAnchor.constraint(
            equalTo: leftAnchor, constant: inset)
        
        // Activate the constraints
        invisibleWidthConstraint?.isActive = true
        invisibleLeftConstraint?.isActive = true
    }
}


extension CarouselCollectionView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateOffSet()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
        guard let indexPath = currentCenterCellIndex else { return }
        self.delegateCorousel?.updatePage(page: indexPath.row)
        lastCurrentCenterCellIndex = indexPath
    }
    
    private func updateOffSet() {
        contentOffset = invisibleScrollView.contentOffset
    }
}


class CarouselLayout: UICollectionViewFlowLayout {
    
    open var inset: CGFloat = 0.0
    
    convenience init(withCarouselInset inset: CGFloat = 0.0) {
        self.init()
        self.inset = inset
    }
    
    override open func prepare() {
        
        guard let collectionViewSize = collectionView?.frame.size else { return }
        
        itemSize = collectionViewSize
        itemSize.width = itemSize.width - (inset * 2)
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        
        sectionInset = UIEdgeInsets(top: 0.0, left:inset, bottom: 0.0, right: inset)
        footerReferenceSize = CGSize.zero
        headerReferenceSize = CGSize.zero
    }
}
