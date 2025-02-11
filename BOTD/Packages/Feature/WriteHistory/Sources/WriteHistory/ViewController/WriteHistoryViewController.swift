//
//  WriteHistoryViewController.swift
//  WriteHistory
//
//  Created by 정다은 on 1/24/25.
//

import UIKit
import RxDataSources
import RxSwift
import SnapKit
import Extension

public final class WriteHistoryViewController: UIViewController {
    public init(coordinator: WriteHistoryCoordinatorProtocol, viewModel: WriteHistoryViewModelProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let coordinator: WriteHistoryCoordinatorProtocol
    private let viewModel: WriteHistoryViewModelProtocol
    private let disposeBag = DisposeBag()
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    private var dataSource: DataSource<WriteHistorySection>?
    
    private lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            return self?.dataSource?.sectionModels[index].layoutSize
            ?? WriteHistorySection.titleHeader([]).layoutSize
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    private let completeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.background.cornerRadius = 8
        config.background.backgroundColor = .beige700
        config.attributedTitle = .init("작성 완료", font: .boldSystemFont(ofSize: 16), color: .white)
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
        
        title = "기록 작성"
        
        view.backgroundColor = .white
        view.addSubviews(collectionView, completeButton)
        
        setupConstraints()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        
        let dataSource = DataSource<WriteHistorySection> { [weak self] _, collectionView, indexPath, item in
            let cellID = String(describing: item.cellStyle)
            collectionView.register(item.cellStyle, forCellWithReuseIdentifier: cellID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            (cell as? WriteHistoryCellProtocol)?.apply(cellData: item)
            
            if let cell = cell as? WriteHistoryInputFieldCell {
                if case .dateInputField = item {
                    cell.dateChangedHandler = { [weak self] date in
                        self?.viewModel.selectDate(date)
                    }
                    cell.beginEditingHandler = nil
                } else if case .bookTitleInputField = item {
                    cell.beginEditingHandler = { [weak self] in
                        self?.moveToSelectBook()
                    }
                    cell.dateChangedHandler = nil
                }
            } else if let cell = cell as? WriteHistoryMemoEmptyCell {
                cell.addButtonTappedHandler = { [weak self] in
                    if case .passageEmpty = item {
                        self?.viewModel.addPassage("a") // TODO: 구절 작성
                    } else if case .memoEmpty = item {
                        self?.viewModel.addMemo("b") // TODO: 메모 작성
                    }
                }
            } else if let cell = cell as? WriteHistoryAddMemoCell {
                cell.addButtonTappedHandler = { [weak self] in
                    if case .addPassage = item {
                        self?.viewModel.addPassage("a") // TODO: 구절 작성
                    } else if case .addMemo = item {
                        self?.viewModel.addMemo("b") // TODO: 메모 작성
                    }
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapCloseButton() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func tapped() {
        view.endEditing(true)
    }
    
    private func moveToSelectBook() {
        coordinator.pushSearchBookVC(bookSelectedHandler: { [weak self] book in
            self?.viewModel.selectBook(book)
        })
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(completeButton.snp.top).offset(-12)
        }
        completeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            make.height.equalTo(56)
        }
    }
}
