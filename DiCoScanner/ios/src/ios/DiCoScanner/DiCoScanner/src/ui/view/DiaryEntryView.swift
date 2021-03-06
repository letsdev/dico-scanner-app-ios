//
//  DiaryEntryView.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class DiaryEntryView: UIView {

    var delegate: DiaryEntryViewDelegate?
    var diaryEntry: SymptomDiaryEntry? {
        didSet {
            self.testDateLabel.text = diaryEntry?.dateLabel()
            setupTestResultLabel()
        }
    }
    @IBOutlet weak var testDateLabel: UILabel!
    @IBOutlet var testResultLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupXib()
    }

    private func setupTestResultLabel() {
        testResultLabel.textColor = diaryEntry!.resultLabelColor()
        testResultLabel.text = diaryEntry!.resultLabel()
    }

    private func setupXib() {
        let nib = UINib(nibName: String(describing: DiaryEntryView.self), bundle: nil)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        contentView.frame = self.bounds

        self.addSubview(contentView)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickEntry(_:))))
        
    }

    @objc func didClickEntry(_ sender: UIPanGestureRecognizer) {
        delegate?.didClick(entry: diaryEntry)
    }

}
