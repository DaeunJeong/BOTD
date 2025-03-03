//
//  LibraryViewController.swift
//  Library
//
//  Created by 정다은 on 2/19/25.
//

import UIKit
import RxDataSources
import RxSwift
import SnapKit
import EventBus

public final class LibraryViewController: UIViewController {
    public init(coordinator: LibraryCoordinatorProtocol, viewModel: LibraryViewModelProtocol, eventBus: EventBusProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.eventBus = eventBus
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let coordinator: LibraryCoordinatorProtocol
    private let viewModel: LibraryViewModelProtocol
    private let eventBus: EventBusProtocol
    private let disposeBag = DisposeBag()
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    private var dataSource: DataSource<LibrarySection>?
    
    private lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            return self?.dataSource?.sectionModels[index].layoutSize
            ?? LibrarySection.books([]).layoutSize
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
        
        viewModel.getBooks()
        
        eventBus.asObservable()
            .bind(onNext: { [weak self] event in
                guard case .refreshHistories = event else { return }
                self?.viewModel.getBooks()
            }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        let dataSource = DataSource<LibrarySection> { [weak self] _, collectionView, indexPath, item in
            let cellID = String(describing: item.cellStyle)
            collectionView.register(item.cellStyle, forCellWithReuseIdentifier: cellID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            (cell as? LibraryCellProtocol)?.apply(cellData: item)
            
            if let cell = cell as? LibraryAddBookCell {
                cell.addButtonTappedHandler = { [weak self] in
                    self?.coordinator.presentWriteHistoryVC()
                }
            } else if let cell = cell as? LibraryEmptyCell {
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
                .bind(to: collectionView.rx.items(dataSource: dataSource)),
            collectionView.rx.modelSelected(LibraryCellData.self)
                .bind(onNext: { [weak self] item in
                    guard case let .book(bookID, _) = item else { return }
                    self?.coordinator.presentHistoryDetailVC(bookID: bookID)
                })
        )
    }
}
