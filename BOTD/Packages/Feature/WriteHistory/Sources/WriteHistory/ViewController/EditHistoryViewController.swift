//
//  EditHistoryViewController.swift
//  WriteHistory
//
//  Created by 정다은 on 2/25/25.
//

import UIKit
import RxDataSources
import RxSwift

public class EditHistoryViewController: UIViewController {
    public init(coordinator: EditHistoryCoordinatorProtocol, viewModel: EditHistoryViewModelProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let coordinator: EditHistoryCoordinatorProtocol
    private let viewModel: EditHistoryViewModelProtocol
    private let disposeBag = DisposeBag()
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    private var dataSource: DataSource<EditHistorySection>?
    
    private lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            return self?.dataSource?.sectionModels[index].layoutSize
            ?? EditHistorySection.titleHeader([]).layoutSize
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
        config.attributedTitle = .init("수정 완료", font: .boldSystemFont(ofSize: 16), color: .white)
        let button = UIButton(configuration: config)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = .beige500
            default:
                button.configuration?.background.backgroundColor = .beige700
            }
        }
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
        title = "기록 수정"
        view.addSubviews(collectionView, completeButton)
        completeButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
        
        setupCollectionView()
        setupBindings()
        setupConstraints()
        
        viewModel.getHistory()
    }
    
    @objc private func tapCloseButton() {
        navigationController?.dismiss(animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        
        let dataSource = DataSource<EditHistorySection> { [weak self] _, collectionView, indexPath, item in
            let cellID = String(describing: item.cellStyle)
            collectionView.register(item.cellStyle, forCellWithReuseIdentifier: cellID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            (cell as? EditHistoryCellProtocol)?.apply(cellData: item)
            
            if let cell = cell as? WriteHistoryMemoEmptyCell {
                cell.addButtonTappedHandler = { [weak self] in
                    if case .passageEmpty = item {
                        self?.moveToWritePassage()
                    } else if case .memoEmpty = item {
                        self?.moveToWriteMemo()
                    }
                }
            } else if let cell = cell as? WriteHistoryAddMemoCell {
                cell.addButtonTappedHandler = { [weak self] in
                    if case .addPassage = item {
                        self?.moveToWritePassage()
                    } else if case .addMemo = item {
                        self?.moveToWriteMemo()
                    }
                }
            } else if let cell = cell as? WriteHistoryMemoCell {
                cell.deleteButtonTappedHandler = { [weak self] in
                    if case .passage = item {
                        self?.viewModel.deletePassage(index: indexPath.item)
                    } else if case .memo = item {
                        self?.viewModel.deleteMemo(index: indexPath.item)
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
    
    private func setupBindings() {
        viewModel.isEnabledToComplete
            .observe(on: MainScheduler.instance)
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc private func tapped() {
        view.endEditing(true)
    }
    
    @objc private func tapCompleteButton() {
        viewModel.editHistory()
        let alert = UIAlertController(title: "수정 완료", message: "기록이 수정되었습니다", preferredStyle: .alert)
        alert.addAction(.init(title: "확인", style: .default, handler: { [weak self] _ in
            self?.navigationController?.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    private func moveToWritePassage() {
        coordinator.pushWriteMemoVC(title: "구절 작성", completeHandler: { [weak self] passage in
            self?.viewModel.addPassage(passage)
        })
    }
    
    private func moveToWriteMemo() {
        coordinator.pushWriteMemoVC(title: "메모 작성", completeHandler: { [weak self] memo in
            self?.viewModel.addMemo(memo)
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
