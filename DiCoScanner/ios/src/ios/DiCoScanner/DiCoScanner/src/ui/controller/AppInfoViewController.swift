//
//  AppInfoViewController.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var appInfoTableView: UITableView!
    private var appInfoSections: [String] = ["ALLGEMEIN", "RECHTLICHE HINWEISE"]
    private var appInfoItems: [[AppInfoItem]] = [[AppInfoItem(identifier: "push", displayName: "Push Benachrichtigungen"), AppInfoItem(identifier: "websites", displayName: "Hilfreiche Websites"), AppInfoItem(identifier: "infografik", displayName: "Infografik")], [AppInfoItem(identifier: "terms", displayName: "Nutzungsbedingungen"), AppInfoItem(identifier: "privacy", displayName: "Datenschutzrichtlinie"), AppInfoItem(identifier: "conditions", displayName: "Bedingungen"), AppInfoItem(identifier: "imprint", displayName: "Impressum"), AppInfoItem(identifier: "about", displayName: "Über die App")]]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "App-Info"
        navigationController?.navigationBar.prefersLargeTitles = true

        setupAppInfoTableView()
    }

    private func setupAppInfoTableView() {
        appInfoTableView.delegate = self
        appInfoTableView.dataSource = self
        appInfoTableView.tableFooterView = UIView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return appInfoSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appInfoItems[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return appInfoSections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: String(describing: UITableViewCell.self))
        }

        cell = setupCell(cell: cell!, appInfoItem: appInfoItems[indexPath.section][indexPath.item])

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appInfoItem = appInfoItems[indexPath.section][indexPath.item]
        let webViewController = WebViewViewController()
        if let url = appInfoItem.url {
            webViewController.title = appInfoItem.displayName
            webViewController.loadUrl(url: URL(string: url))
            self.navigationController?.pushViewController(webViewController, animated: true)
        } else if let localUrl = appInfoItem.localUrl {
            if let bundleHtml = Bundle.main.url(forResource: localUrl, withExtension: "html") {
                webViewController.title = appInfoItem.displayName
                webViewController.loadUrl(url: bundleHtml)
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }

    func setupCell(cell: UITableViewCell, appInfoItem: AppInfoItem) -> UITableViewCell {
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none

        cell.textLabel?.text = appInfoItem.displayName

        return cell
    }
}
