//
//  CharacterDetailsVC.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 19.11.23.
//

import UIKit
import Combine
import AVFoundation

final class CharacterDetailsVC: BaseVC {
    
    // MARK: - Properties

    let titlesArray = ["Gender", "Status", "Specie", "Origin", "Type", "Location"]

    // MARK: - Subviews
    
    private var profileImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        
        return v
    }()
    
    private var cameraButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "cameraButton"), for: .normal)
        v.addTarget(self, action: #selector(didSelectCameraButton(_ :)),
                    for: .touchUpInside)
        
        return v
    }()
    
    private var nameLabel: UILabel = {
        let v = UILabel()
        v.text = "Rick Sanchez"
        v.font = .systemFont(ofSize: 32)
        v.textAlignment = .center
        
        return v
    }()
    
    private var infoLabel: UILabel = {
        let v = UILabel()
        v.text = "Informations"
        v.font = .systemFont(ofSize: 24, weight: .semibold)
        v.textColor = UIColor(hex: "#8E8E93")
        
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.separatorStyle = .none
        v.backgroundColor = .white
        v.isScrollEnabled = true
        v.showsVerticalScrollIndicator = false
        
        return v
    }()
    
    private let presenter: CharacterDetailsPresenterProtocol
    private var model: Custom?
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: CharacterDetailsPresenterProtocol, model: Custom) {
        self.presenter = presenter
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupProfileImageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSubviews()
        setupTableView()
        setupNavigationBar()
        setupImage()
        setupCharacters(name: model?.characterName ?? "Name is Unknown")
        bind()
        
    }
    
    // MARK: - Bind
    
    public override func bind() {
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            profileImageView,
            cameraButton,
            nameLabel,
            infoLabel,
            tableView
        ])
    }
    
    public override func setupAutolayout() {
        
        profileImageView.pin(edges: [.top], to: view, inset: 20, toSafeArea: true)
        nameLabel.pin(edges: [.leading, .trailing], to: view, inset: 20)
        infoLabel.pin(edges: [.leading, .trailing], to: view, inset: 20)
        tableView.pin(edges: [.leading,], to: view, inset: 10)
        tableView.pin(edges: [.trailing], to: view, inset: 40)
        tableView.pin(edges: [.bottom],to: view, inset: 16, toSafeArea: true)
        
        profileImageView.set(width: 150, height: 150)
        cameraButton.set(width: 32, height: 32)
        nameLabel.set(height: 33)
        infoLabel.set(height: 24)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            cameraButton.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor, constant: 10),
            cameraButton.centerYAnchor.constraint(
                equalTo: profileImageView.centerYAnchor),
            nameLabel.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor, constant: 40),
            infoLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor, constant: 20),
            tableView.topAnchor.constraint(
                equalTo: infoLabel.bottomAnchor, constant: 20),
        ])
    }
    
    // MARK: - Other funcs
    
    private func setupNavigationBar() {
        // setup back icon
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "goBack"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(
            top: 0, left: -8, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(backButtonAction),
                             for: .touchUpInside)
        backButton.tintColor = .black
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // setup right icon
        let buttonImage = UIImage(named: "logo")
        let rightButton = UIBarButtonItem(image: buttonImage,
                                          style: .plain, target: self, action: nil)
        rightButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor(hex: "#F2F2F7").cgColor
        profileImageView.layer.borderWidth = 4
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterDetailsTableViewCell.self)
        tableView.separatorStyle = .singleLine
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
    
    private func setupImage() {
        
        if let url = URL(string: model?.characterImage ?? "") {
            loadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }

    }
    
    private func setupCharacters(name: String) {
        DispatchQueue.main.async {
            self.nameLabel.text = name
        }
    }

    
    // MARK: - ImagePicker
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Загрузите изображение", message: nil, preferredStyle: .actionSheet)
        
        let actions = [
            UIAlertAction(title: "Камера", style: .default) {[weak self] _ in
                guard let self else { return }
                self.showCamera()
            },
            
            UIAlertAction(title: "Галерея", style: .default) {[weak self] _ in
                guard let self else { return }
                self.showPhotoLibrary()
            },
            
            
            UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        ]
        
        actions.forEach {
            alertController.addAction($0)
        }
        
        self.present(alertController, animated: true)
    }
    
    func presentImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func makeCameraAccessAlert() -> UIAlertController {
        
        let alert = UIAlertController(
            title: "Camera Access Denied",
            message: "To use the camera, please update your settings to allow camera access.",
            preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    func showCamera() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.presentImagePickerController()
                    }
                }
            }
        default:
            self.present(makeCameraAccessAlert(), animated: true)
        }
    }
    
    func showPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Callbacks
    
    @objc func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didSelectCameraButton(_ sender: UIButton) {
        self.presentAlert()
    }
    
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension CharacterDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
            picker.dismiss(animated: true)
        }
    }
}

extension CharacterDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
}

extension CharacterDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        titlesArray.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(cell: CharacterDetailsTableViewCell.self, for: indexPath)

        if let model = model {
            switch indexPath.row {
            case 0:
                cell.configure(title: titlesArray[indexPath.row],
                               description: model.gender)
            case 1:

                cell.configure(title: titlesArray[indexPath.row],
                               description: model.status)
            case 2:

                cell.configure(title: titlesArray[indexPath.row],
                               description: model.specie)
            case 3:

                cell.configure(title: titlesArray[indexPath.row],
                               description: model.origin.name)
            case 4:

                cell.configure(title: titlesArray[indexPath.row],
                               description: model.type)
            case 5:
                cell.configure(title: titlesArray[indexPath.row],
                               description: model.location.name)
            default:
                break
            }
            
        }
        
        return cell
    }
    
}

