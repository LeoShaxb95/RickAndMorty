//
//  EpisodesVC.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit
import Combine

class EpisodesVC: BaseVC {
    
    // MARK: - Properties
    
    enum filterType {
        case episodeNumber
        case episodeName
        case characterName
    }
    
    private var filterType: filterType = .episodeNumber
    var collectionViewTopConstraint: CGFloat = 60
    let SegmentControlItems = ["Episode number", "Episode name", "Character name"]
        
    private let presenter: EpisodesPresenter
    private let apiManager: ApiManagerProtocol
    private let cacheManager: CacheManagerProtocol
    var cancellables = Set<AnyCancellable>()
    
    private var charactersData: Characters?
    private var episodesData: [Results]? = []
    private var filteredEpisodesData: [Custom]?
    private var customData: [Custom]? = []
    
    // MARK: - Subviews
    
    private var titleImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.image = UIImage(named: "RickAndMorty")
        
        return v
    }()
    
    let searchTextField: UITextField = {
        let leftView = UIView(frame: CGRect(
            x: 0, y: 0, width: 50, height: 30))
        let iconImageView = UIImageView(frame: CGRect(
            x: 20, y: 5, width: 24, height: 24))
        iconImageView.image = UIImage(named: "SearchIcon")
        leftView.addSubview(iconImageView)
        
        let v = UITextField()
        v.placeholder = "Name or episode (ex.S01E01)..."
        v.font = .systemFont(ofSize: 16, weight: .regular)
        v.autocorrectionType = .no
        v.layer.borderColor = UIColor(hex: "#808080").cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 8
        
        v.leftView = leftView
        v.leftViewMode = .always
        
        return v
    }()
    
    private var filtersButton: UIButton = {
        let v = UIButton()
        v.isUserInteractionEnabled = true
        v.isEnabled = true
        v.setTitle("ADVANCED FILTERS", for: .normal)
        v.setTitleColor(UIColor(hex: "#2196F3"), for: .normal)
        v.backgroundColor = UIColor(hex: "#E3F2FD")
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.layer.cornerRadius = 8
        v.addTarget(self, action: #selector(didSelectFilterIconButton(_ :)),
                          for: .touchUpInside)
        
        return v
    }()
    
    private var filterIconButton: UIButton = {
        let v = UIButton()
        v.isUserInteractionEnabled = true
        v.isEnabled = true
        v.tintColor = UIColor(hex: "#E3F2FD")
        v.setImage(UIImage(named: "Filter"), for: .normal)
        v.addTarget(self, action: #selector(didSelectFilterIconButton(_ :)),
                    for: .touchUpInside)
        
        return v
    }()
    
    lazy var filterTypesSegmentedControl: UISegmentedControl = {
        let v = UISegmentedControl(items: SegmentControlItems )
        v.selectedSegmentIndex = 0
        v.layer.masksToBounds = true
        v.tintColor = .blue
        v.layer.borderColor = UIColor.white.cgColor
        v.backgroundColor = UIColor(hex: "#E3F2FD")
        v.selectedSegmentTintColor = .white

        let font = UIFont.systemFont(ofSize: 40)
        let segmentFont = [NSAttributedString.Key.font: font]
        v.setTitleTextAttributes(segmentFont, for: .selected)

        let selectedSegment = [NSAttributedString.Key.foregroundColor: UIColor.black]
        v.setTitleTextAttributes(selectedSegment, for:.selected)

        let deselectedSegment = [NSAttributedString.Key.foregroundColor: UIColor(hex: "#2196F3")]
        v.setTitleTextAttributes(deselectedSegment, for:.normal)

        v.addTarget(self, action: #selector(didChangeSelectedSegment(_ :)),
                          for: .valueChanged)

        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        return UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    }()
    
    // MARK: - Init
    
    init(presenter: EpisodesPresenter,
         apiManager: ApiManagerProtocol,
         cacheManager: CacheManagerProtocol) {
        
        self.presenter = presenter
        self.apiManager = apiManager
        self.cacheManager = cacheManager

        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.tabBarItem.selectedImage = UIImage(named: "HomeSelected")
        searchTextField.delegate = self
        filteredEpisodesData = customData
        filterTypesSegmentedControl.isHidden = true
        
        fetchCustomData()
        collectionViewConfigurations()
        self.collectionView.reloadData()
        setupSubviews()
        bind()
        
    }
    
    // MARK: - Bind
    
    public override func bind() {
        
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            titleImageView,
            searchTextField,
            filtersButton,
            filterIconButton,
            filterTypesSegmentedControl,
            collectionView
        ])
    }
    
    public override func setupAutolayout() {
        
        titleImageView.pin(edges: [.top], to: view, inset: -20, toSafeArea: true)
        titleImageView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        searchTextField.pin(edges: [.leading, .trailing], to: view, inset: 30)
        filtersButton.pin(edges: [.leading, .trailing], to: view, inset: 30)
        filterTypesSegmentedControl.pin(edges: [.leading, .trailing], to: view, inset: 30)
        collectionView.pin(edges: [.leading, .trailing], to: view, inset: 30)

        titleImageView.set(height: 104)
        searchTextField.set(height: 56)
        filtersButton.set(height: 56)
        filterIconButton.set(width: 20, height: 20)
        filterTypesSegmentedControl.set(height: 30)

        NSLayoutConstraint.activate([
            titleImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            searchTextField.topAnchor.constraint(
                equalTo: titleImageView.bottomAnchor, constant: 50),
            filtersButton.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor, constant: 20),
            filterIconButton.centerYAnchor.constraint(
                    equalTo: filtersButton.centerYAnchor),
            filterIconButton.leadingAnchor.constraint(
                    equalTo: filtersButton.leadingAnchor, constant: 20),
            filterTypesSegmentedControl.topAnchor.constraint(
                    equalTo: filtersButton.bottomAnchor, constant: 5),
            filterTypesSegmentedControl.leadingAnchor.constraint(
                    equalTo: filtersButton.leadingAnchor, constant: 20),
            collectionView.topAnchor.constraint(
                equalTo: filterIconButton.bottomAnchor, constant: 60),
            collectionView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor, constant: -20),
    
        ])
        
        collectionView.layer.cornerRadius = 4
    }
    
    // MARK: - Other funcs
    
    private func fetchCustomData() {
        
        if let cachedEpisodes = cacheManager.loadObject(forKey: "customData", type: [Custom].self) as? [Custom] {
            self.customData = cachedEpisodes
            self.filteredEpisodesData = cachedEpisodes
            print(self.customData)
            self.collectionView.reloadData()
        } else {
            fetchFromNetwork()
        }
    }
    
    func fetchFromNetwork() {
        let dispatchGroup = DispatchGroup()
        
        apiManager.getEpisode { [weak self] result in
            guard let self = self else { return }
            
            for episode in result {
                dispatchGroup.enter()
                self.makeCustomFrom(episode: episode) { customData in
                    self.customData?.append(customData)
                    self.downloadImage(from: customData.characterImage) { image in
                        guard let image else { return }
                        self.cacheManager.saveImage(image, forKey: customData.characterName)
                        self.collectionView.reloadData()
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.filteredEpisodesData = self.customData
                self.cacheManager.saveObject(self.customData, forKey: "customData")
                self.collectionView.reloadData()
            }
        }
    }
    
    private func makeCustomFrom(episode: Results, completion: @escaping (Custom) -> Void) {
        var characterImage = String()
        var characterName = String()
        var gender = String()
        var status = String()
        var specie = String()
        var origin = Location(name: "", url: "")
        var type = String()
        var location = Location(name: "", url: "")
        
        apiManager.getCharacter(url: episode.characters[5]) { characters in
            characterImage = characters.image
            characterName = characters.name
            gender = characters.gender
            status = characters.status
            specie = characters.species
            origin = characters.origin
            type = characters.type
            location = characters.location
                
        var result = Custom(
            characterImage: characterImage,
            characterName: characterName,
            episodeName: episode.name,
            episodeNumber: episode.episode,
            isFavorite: false,
            gender: gender,
            status: status,
            specie: specie,
            origin: origin,
            type: type,
            location: location
        )
            
            completion(result)
        }
    }
    
    private func collectionViewConfigurations() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EpisodesCollectionViewCell.self, forCellWithReuseIdentifier: EpisodesCollectionViewCell.identifier)

    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
    
    private func filterEpisodes(with searchText: String) {
        if searchText.isEmpty {
            filteredEpisodesData = customData
        } else {
            var result = false
            filteredEpisodesData = customData?.filter { episode in
                switch self.filterType {
                case .characterName:
                    result = episode.characterName.contains(searchText)
                case .episodeName:
                    result = episode.episodeName.contains(searchText)
                case .episodeNumber:
                    result = episode.episodeNumber.contains(searchText)
                }
                return result
            }
        }
        collectionView.reloadData()
    }

    // MARK: Callbacks
    
    @objc func didChangeSelectedSegment(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.filterType = .episodeNumber
        case 1:
            self.filterType = .episodeName
        case 2:
            self.filterType = .characterName
        default:
            break
        }
        
        guard let text = self.searchTextField.text else { return }
        filterEpisodes(with: text)
        self.collectionView.reloadData()
    }
    
    @objc func didSelectFilterIconButton(_ sender: UIButton) {
        if self.filterTypesSegmentedControl.isHidden == true {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.filterTypesSegmentedControl.alpha = 1
            }, completion: { _ in
                self.filterTypesSegmentedControl.isHidden = false
            })
           
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.filterTypesSegmentedControl.alpha = 0
            }, completion: { _ in
                self.filterTypesSegmentedControl.isHidden = true
            })
        }
    }
    
}

extension EpisodesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let data = filteredEpisodesData {
            return data.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodesCollectionViewCell.identifier,
            for: indexPath) as? EpisodesCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.delegate = self
        
        var characterImage = cacheManager.loadImage(forKey: self.customData?[indexPath.row].characterName ?? "")

        cell.configure(
            episodeName: self.filteredEpisodesData?[indexPath.row].episodeName ?? "aa",
            episodeNumber: self.filteredEpisodesData?[indexPath.row].episodeNumber ?? "bb",
            characterImage: characterImage,
            characterName: self.filteredEpisodesData?[indexPath.row].characterName ?? ""
        )
        
        return cell
    }
    
}

extension EpisodesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.customData else { return }

        self.presenter.moveToCharacterDetailsScreen(data[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 360

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 60
    }
}

extension EpisodesVC: EpisodesCollectionViewCellDelegate {
    func didTapFavoriteButton(in cell: EpisodesCollectionViewCell) {
        print("dzec")
        guard let indexPathRow = collectionView.indexPath(for: cell)?.row else { return }
        
        // when make favorite
        if cell.episodeFavoriteButton.imageView?.image ==
            UIImage(named: "FavoriteEmpty") {
            if let customData = self.customData {
                let episodeNumber = customData[indexPathRow].episodeNumber
                
                var currentArray = cacheManager.loadArray(withFileName: "favorites") ?? []
                currentArray.append(episodeNumber)
                cacheManager.save(array: currentArray, withFileName: "favorites")
                
                print(currentArray)
            }
        } else {
            if let customData = self.customData {
                let episodeNumber = customData[indexPathRow].episodeNumber
                
                var currentArray = cacheManager.loadArray(withFileName: "favorites") ?? []
                currentArray.removeAll { $0 == episodeNumber }
                cacheManager.save(array: currentArray, withFileName: "favorites")
                
                print(currentArray)
            }
        }
    }
}

extension EpisodesVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
            
        filterEpisodes(with: searchText)
    }
}
