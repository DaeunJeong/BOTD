//
//  WriteMemoViewController.swift
//  WriteHistory
//
//  Created by 정다은 on 2/12/25.
//

import UIKit
import RxCocoa
import RxSwift

public final class WriteMemoViewController: UIViewController {
    public init(title: String, completeHandler: @escaping (String) -> Void) {
        self.completeHandler = completeHandler
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let completeHandler: (String) -> Void
    private let disposeBag = DisposeBag()
    private let textView = UITextView()
    private let completeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.background.cornerRadius = 8
        config.background.backgroundColor = .beige700
        config.attributedTitle = .init("작성 완료", font: .boldSystemFont(ofSize: 16), color: .white)
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
        
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal),
                                                 style: .plain, target: self, action: #selector(tapBackButton))
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubviews(textView, completeButton)
        setupConstraints()
        setupBindings()
        
        textView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textView.layer.borderColor = UIColor.gray400.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
        completeButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
    }
    
    @objc private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapped() {
        textView.resignFirstResponder()
    }
    
    @objc private func tapCompleteButton() {
        completeHandler(textView.text)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupBindings() {
        textView.rx.text
            .map({ $0?.isEmpty == false })
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(completeButton.snp.top).offset(-24)
        }
        completeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
            make.height.equalTo(56)
        }
    }
}
