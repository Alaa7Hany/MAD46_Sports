//
//  TeamTableViewController.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

import UIKit
import SDWebImage
import SkeletonView

protocol TeamView: AnyObject {
    func reloadData()
    func showError(message: String)
}

class TeamTableViewController: UITableViewController, TeamView {
       var teamHeaderView     = TeamTableHeaderView.loadFromNib()

   
     private lazy var emptyStateView = TeamEmptyStateView.loadFromNib()

    var presenter : TeamPresenter!
    private let sections = TeamSection.allCases
    private var isLoadingData: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBackground
        tableView.backgroundColor = .appBackground
        tableView.separatorStyle = .none
        
        presenter.attachView(self)
        configureTableView()
        setupTableHeader()
        
        showHeaderSkeleton()
        
        presenter.fetchTeamDetails()
    
        let nib = UINib(nibName: "TeamSectionHeaderView", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TeamSectionHeader")
 
    }
    
     func setupTableHeader() {
        teamHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 180)
        tableView.tableHeaderView = teamHeaderView
    }

     func configureTableView() {
         tableView.register(
            UINib(nibName: "TeamViewCell", bundle: nil),
            forCellReuseIdentifier: "TeamViewCell"
        )
        tableView.register(
            UINib(nibName: "TeamSectionHeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier:"TeamSectionHeader"
        )
    }

    
    private func showHeaderSkeleton() {
        teamHeaderView.showAnimatedGradientSkeleton(
            usingGradient: .init(baseColor: .systemGray6),
            animation: nil,
            transition: .crossDissolve(0.25)
        )
    }
    
    private func hideHeaderSkeleton() {
        teamHeaderView.hideSkeleton(
            reloadDataAfter: false,
            transition: .crossDissolve(0.25)
        )
    }

       private func updateEmptyState() {
        let isEmpty = visibleSections().isEmpty

        if isEmpty && !isLoadingData {
            if emptyStateView.superview == nil {
                   emptyStateView.frame = CGRect(
                    x: 0,
                    y: tableView.contentOffset.y + 60,
                    width: tableView.bounds.width,
                    height: tableView.bounds.height
                )
                emptyStateView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                tableView.addSubview(emptyStateView)
            }
            emptyStateView.isHidden = false
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0.4,
                           options: .curveEaseOut) {
                self.emptyStateView.alpha = 1
                self.emptyStateView.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.emptyStateView.alpha = 0
            } completion: { _ in
                self.emptyStateView.isHidden = true
            }
        }
    }

     

     func players(for section: TeamSection) -> [PlayerModel] {
        switch section {
        case .goalkeepers: return presenter.getGoalkeepers()
        case .defenders: return presenter.getDefenders()
        case .midfielders: return presenter.getMidfielders()
        case .forwards: return presenter.getForwards()
        }
    }

    private func visibleSections() -> [TeamSection] {
        sections.filter { !players(for: $0).isEmpty }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadingData { return 1 }
        return visibleSections().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadingData { return 5 }
        let sectionType = visibleSections()[section]
        return players(for: sectionType).count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoadingData { return nil }
        let sectionType = visibleSections()[section]
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "TeamSectionHeader"
        ) as? TeamSectionHeaderView else { return nil }
        header.sectionLabel.text = "\(sectionType.icon)  \(sectionType.title)"
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoadingData { return 0 }
        return 50
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TeamViewCell",
                for: indexPath
            ) as? TeamViewCell
        else {
            return UITableViewCell()
        }

        if isLoadingData {
            return cell
        }

        let sectionType = visibleSections()[indexPath.section]
        let player = players(for: sectionType)[indexPath.row]

        let sport = presenter.sportName.lowercased()
        let placeholderName: String
        if sport.contains("basketball") { placeholderName = "basketball" }
        else if sport.contains("cricket") { placeholderName = "cricket" }
        else if sport.contains("tennis") { placeholderName = "tennis" }
        else { placeholderName = "football" }
        
        let placeholder = UIImage(named: placeholderName)

        let playerName = player.playerName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.nameLabel.numberOfLines = 2
        cell.nameLabel.text = playerName.isEmpty ? NSLocalizedString("UNKNOWN_PLAYER", comment: "") : playerName

        let playerNumber = player.playerNumber?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.numberLabel.text = playerNumber.isEmpty ? "-" : playerNumber

        let playerAge = player.playerAge?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.subtitleLabel.text = playerAge.isEmpty ? NSLocalizedString("AGE_UNKNOWN", comment: "") : String(format: NSLocalizedString("AGE_VALUE", comment: ""), playerAge)

        cell.roleBadgeLabel.text = sectionType.badgeText
        cell.roleBadgeLabel.backgroundColor = sectionType.badgeColor

        if let image = player.playerImage, !image.isEmpty, let url = URL(string: image) {
            cell.avatarImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            cell.avatarImageView.image = placeholder
        }

        return cell
    }
    
    // MARK: - Per-cell Skeleton via willDisplay
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoadingData {
            cell.showAnimatedGradientSkeleton(
                usingGradient: .init(baseColor: .systemGray6),
                animation: nil,
                transition: .crossDissolve(0.25)
            )
        }
    }
    

    func reloadData() {
        self.isLoadingData = false
        
        hideHeaderSkeleton()
        
        let teamName = presenter.getTeamName().trimmingCharacters(in: .whitespacesAndNewlines)
        teamHeaderView.teamNameLabel.text = teamName.isEmpty ? NSLocalizedString("UNKNOWN_TEAM", comment: "") : teamName
        
        let placeholderName: String
        let sport = presenter.sportName.lowercased()
        if sport.contains("basketball") { placeholderName = "basketball" }
        else if sport.contains("cricket") { placeholderName = "cricket" }
        else if sport.contains("tennis") { placeholderName = "tennis" }
        else { placeholderName = "football" }
        let placeholder = UIImage(named: placeholderName)

        let logo = presenter.getTeamLogo()
        if let url = URL(string: logo), !logo.isEmpty {
            teamHeaderView.teamLogoImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            teamHeaderView.teamLogoImageView.image = placeholder
        }

        tableView.reloadData()
        updateEmptyState()
    }

    

    func showError(message: String) {
        self.isLoadingData = false
        hideHeaderSkeleton()
        tableView.reloadData()
        
        let alert = UIAlertController(
            title: NSLocalizedString("TEAM_ERROR_TITLE", comment: ""),
            message: "\n" + message,
            preferredStyle: .actionSheet
        )
        let titleAttr = NSAttributedString(
            string: NSLocalizedString("TEAM_ERROR_TITLE", comment: ""),
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor.systemOrange
            ]
        )
        let msgAttr = NSAttributedString(
            string: "\n" + message,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        alert.setValue(titleAttr, forKey: "attributedTitle")
        alert.setValue(msgAttr,   forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: NSLocalizedString("TEAM_ERROR_OK", comment: ""), style: .cancel))
        present(alert, animated: true)
    }
    
    
}
