//
//  SearchBookViewController.swift
//  WriteHistory
//
//  Created by 정다은 on 2/5/25.
//

import UIKit
import RxDataSources
import RxSwift

public final class SearchBookViewController: UIViewController {
    public init(viewModel: SearchBookViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: SearchBookViewModelProtocol
    private let disposeBag = DisposeBag()
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    private var dataSource: DataSource<SearchBookSection>?
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "책 제목을 입력해 주세요"
        textField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass",
                                                        withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))?
            .withTintColor(.black, renderingMode: .alwaysOriginal))
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.textColor = .black
        textField.keyboardType = .default
        return textField
    }()
    private let borderView = UIView(backgroundColor: .gray400)
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
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal),
                                                 style: .plain, target: self, action: #selector(tapBackButton))
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchTextField.becomeFirstResponder()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "책 검색"
        view.backgroundColor = .white
        view.addSubviews(searchTextField, borderView, collectionView, indicator)
        
        setupConstraints()
        setupCollectionView()
        setupBindings()
    }
    
    private func setupCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        
        let dataSource = DataSource<SearchBookSection> { _, collectionView, indexPath, item in
            let cellID = String(describing: item.cellStyle)
            collectionView.register(item.cellStyle, forCellWithReuseIdentifier: cellID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            (cell as? SearchBookCellProtocol)?.apply(cellData: item)
            
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
        disposeBag.insert(
            searchTextField.rx.text
                .bind(to: viewModel.searchQuery),
            searchTextField.rx.text
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .bind(onNext: { [weak self] _ in
                    self?.search()
                }),
            viewModel.isShownIndicator
                .observe(on: MainScheduler.instance)
                .bind(to: indicator.rx.isAnimating),
            viewModel.errorOccured
                .observe(on: MainScheduler.instance)
                .bind(onNext: { [weak self] in
                    let alert = UIAlertController(title: "오류 발생", message: "결과를 불러오는데 실패하였습니다", preferredStyle: .alert)
                    alert.addAction(.init(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                })
        )
    }
    
    private func search(isPagination: Bool = false) {
        Task { @MainActor [viewModel] in
            await viewModel.search(isPagination: isPagination)
        }
    }
    
    @objc private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapped() {
        searchTextField.resignFirstResponder()
    }
    
    private func setupConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(32)
        }
        borderView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(searchTextField)
            make.height.equalTo(1)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        indicator.snp.makeConstraints({ $0.center.equalToSuperview() })
    }
}
