//
//  HistoryDetailViewController.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/13/25.
//

import UIKit
import RxDataSources
import RxSwift

public final class HistoryDetailViewController: UIViewController {
    public init(coordinator: HistoryDetailCoordinatorProtocol, viewModel: HistoryDetailViewModelProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let coordinator: HistoryDetailCoordinatorProtocol
    private let viewModel: HistoryDetailViewModelProtocol
    private let disposeBag = DisposeBag()
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    private var dataSource: DataSource<HistoryDetailSection>?
    
    private lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            return self?.dataSource?.sectionModels[index].layoutSize
            ?? HistoryDetailSection.header([]).layoutSize
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private let editButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.background.cornerRadius = 8
        config.background.backgroundColor = .beige700
        config.attributedTitle = .init("기록 수정", font: .boldSystemFont(ofSize: 16), color: .white)
        let button = UIButton(configuration: config)
        return button
    }()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal),
                                                 style: .plain, target: self, action: #selector(tapCloseButton))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubviews(collectionView, editButton)
        
        setupCollectionView()
        setupBindings()
        setupConstraints()
        viewModel.getHistoryOfDate()
        
        editButton.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
    }
    
    @objc private func tapCloseButton() {
        navigationController?.dismiss(animated: true)
    }
    
    private func setupCollectionView() {
        let dataSource = DataSource<HistoryDetailSection> { [weak self] _, collectionView, indexPath, item in
            let cellID = String(describing: item.cellStyle)
            collectionView.register(item.cellStyle, forCellWithReuseIdentifier: cellID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            (cell as? HistoryDetailCellProtocol)?.apply(cellData: item)
            
            if let cell = cell as? HistoryDetailHeaderCell {
                cell.previousButtonTappedHandler = { [weak self] in
                    self?.viewModel.moveToPrevious()
                }
                cell.nextButtonTappedHandler = { [weak self] in
                    self?.viewModel.moveToNext()
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
    
    private func setupBindings() {
        viewModel.naviTitle
            .observe(on: MainScheduler.instance)
            .bind(to: rx.title)
            .disposed(by: disposeBag)
    }
    
    @objc private func tapEditButton() {
        guard let historyID = viewModel.getCurrentHistoryID() else { return }
        coordinator.presentEditHistoryVC(historyID: historyID,
                                         completeToEditHandler: { [weak self] in
            self?.viewModel.refreshHistory(id: historyID)
        }, completeToDeleteHandler: { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        })
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(editButton.snp.top).offset(-12)
        }
        editButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            make.height.equalTo(56)
        }
    }
}
