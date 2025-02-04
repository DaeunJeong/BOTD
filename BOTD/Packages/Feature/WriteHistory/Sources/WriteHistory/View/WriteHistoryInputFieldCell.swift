//
//  WriteHistoryInputFieldCell.swift
//  WriteHistory
//
//  Created by 정다은 on 1/28/25.
//

import UIKit

public final class WriteHistoryInputFieldCell: UICollectionViewCell, WriteHistoryCellProtocol {
    private let textField = WriteHistoryInputField()
    private let datePicker = UIDatePicker()
    
    public var dateChangedHandler: ((Date) -> Void)?
    public var beginEditingHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        textField.delegate = self
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
    }
    
    @objc private func changeDate(_ sender: UIDatePicker) {
        textField.text = DateFormatter(dateFormat: "yyyy.MM.dd (E)").string(from: sender.date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(cellData: WriteHistoryCellData) {
        if case let .dateInputField(selectedDate) = cellData {
            let dateFormatter = DateFormatter(dateFormat: "yyyy.MM.dd (E)")
            textField.text = dateFormatter.string(from: selectedDate)
            textField.placeholder = nil
            textField.inputView = datePicker
        } else if case let .bookTitleInputField(text) = cellData {
            textField.text = text
            textField.placeholder = "책 제목을 입력해 주세요"
            textField.inputView = nil
        }
    }
}

extension WriteHistoryInputFieldCell: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        dateChangedHandler?(datePicker.date)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let handler = beginEditingHandler {
            textField.resignFirstResponder()
            handler()
        }
    }
}

private class WriteHistoryInputField: UITextField {
    private let borderView = UIView(backgroundColor: .gray400)
    
    init() {
        super.init(frame: .zero)
        
        addSubview(borderView)
        
        borderView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
