//
//  ViewController.swift
//  Multiple-Sections
//
//  Created by Juan Ceballos on 9/8/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 1
    enum Section: Int, CaseIterable {
        case grid
        case single
        
        // TODO: add a third section
        
        var columnCount: Int {
            switch self { // self represents the instance of the enum
            case .grid:
                return 4 // 4 columns
            case .single:
                return 1 // 1 column
                
            }
        }
    }
    
    // 2
    @IBOutlet weak var collectionView: UICollectionView! // default layout is flow layour
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int> // both args has to conform to Hashable
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    // 4
    private func configureCollectionView() {
        // overwrite the default layout from
        // flow layout to compositional layout
        
        // if done programmatically
        //collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .systemBackground
    }
    
    // 3
    private func createLayout() -> UICollectionViewLayout {
        
        // item
        // group
        // section
        //let layout = UICollectionViewCompositionalLayout(section: section)
        //return layout
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // find out what section we are working with
            guard let sectionType = Section(rawValue: sectionIndex) else {
                return nil
            }
            
            // how many columns
            let columns = sectionType.columnCount // 1 or 4 columns
            
            // create the layout: item -> group -> section -> layout
            
            // item's container => group
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
                // dynamic with columns case, number of
            
            // whats the group's container? => section
            let groupHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(200) : NSCollectionLayoutDimension.fractionalWidth(0.25)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns) // 1 or 4
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
        return layout
    }

    // 5
    private func configureDataSource() {
        // 1
        // setting up the data source
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            // configure the cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as? LabelCell else {
                fatalError("could not dequeue a Label Cell")
            }
            cell.textLabel.text = "\(item)"
            
            if indexPath.section == 0 {
                // first section
                cell.backgroundColor = .systemOrange
            } else {
                cell.backgroundColor = .systemGreen
            }
            return cell
        })
        // 2
        // setup initial snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.grid, .single])
        // careful for duplicate items, thats y it's hashable
        snapshot.appendItems(Array(1...12), toSection: .grid)
        snapshot.appendItems(Array(13...20), toSection: .single)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

