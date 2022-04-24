import UIKit

class HomeTableViewCell: UITableViewCell {

    static var reuseIdentifier = "HomeTableViewCell"

    private let bookIconName = "book"

    let cellView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(.primary)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.applyDefaultContainerShadow()
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(.backgroundSecondary)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor,
                                         multiplier: 1 / 1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        return imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) isn't supported")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareCellView()
        prepareTransactionImageView()
        prepareTitleLabel()
        prepareIcon()
    }

    private func prepareCellView() {
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(cellView, constraints: [
            equal(\.topAnchor, constant: 4),
            equal(\.bottomAnchor, constant: -4),
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func prepareTransactionImageView() {
        cellView.addSubview(iconImageView, constraints: [
            equal(\.leadingAnchor, constant: 18),
            equal(\.centerYAnchor)
        ])
    }

    private func prepareTitleLabel() {
        cellView.addSubview(titleLabel, constraints: [
            equal(\.topAnchor),
            equal(\.trailingAnchor),
            equal(\.bottomAnchor)
        ])
        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
    }

    private func prepareIcon() {
        iconImageView.image = UIImage(systemName: bookIconName)
    }

    func didSelectCell() {
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.green.cgColor
    }

    func didDeselectCell() {
        cellView.layer.borderWidth = 0
        cellView.layer.borderColor = UIColor.clear.cgColor
    }

    func setupData(title: String?, image: String?) {
        titleLabel.text = title
    }
}
