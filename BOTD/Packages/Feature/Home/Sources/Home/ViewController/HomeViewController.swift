//
//  HomeViewController.swift
//  Home
//
//  Created by 정다은 on 1/10/25.
//

import UIKit
import RxDataSources
import RxSwift
import SnapKit

public final class HomeViewController: UIViewController {
    public init(coordinator: HomeCoordinatorProtocol, viewModel: HomeViewModelProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let coordinator: HomeCoordinatorProtocol
    private let viewModel: HomeViewModelProtocol
    private let disposeBag = DisposeBag()
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    private var dataSource: DataSource<HomeSection>?
    
    private lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            return self?.dataSource?.sectionModels[index].layoutSize
            ?? HomeSection.titleHeader([]).layoutSize
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        setupCollectionView()
        
        viewModel.getTodaysHistory()
        viewModel.getLastWeekHistory()
        viewModel.getTodaysPassage()
    }
    
    private func setupCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        let dataSource = DataSource<HomeSection> { [weak self] _, collectionView, indexPath, item in
            let cellID = String(describing: item.cellStyle)
            collectionView.register(item.cellStyle, forCellWithReuseIdentifier: cellID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            (cell as? HomeCellProtocol)?.apply(cellData: item)
            
            if let cell = cell as? HomeTodaysBookCell,
               case let .todaysBook(historyID, _) = item {
                cell.bookViewTappedHandler = { [weak self] in
                    if let historyID = historyID {
                        // TODO: 기록 상세 화면으로 이동
                    } else {
                        self?.coordinator.presentWriteHistoryVC()
                    }
                }
                cell.addButtonTappedHandler = { [weak self] in
                    self?.coordinator.presentWriteHistoryVC()
                }
            }
            
            return cell
        }
        self.dataSource = dataSource
        
        disposeBag.insert(
            viewModel.sections
                .observe(on: MainScheduler.instance)
                .bind(to: collectionView.rx.items(dataSource: dataSource))
        )
    }
}
