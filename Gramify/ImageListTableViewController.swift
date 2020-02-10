//
//  ImageListTableViewController.swift
//  Gramify
//
//  Created by Isaac Akalanne on 29/01/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import UIKit

class ImageListTableViewController: UITableViewController  {
    
    var listOfImgurImages = [ImgurImage]()
    var imageCache = Dictionary<String, UIImage>()
    var selectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.imgur.com/3/album/psT5Lsh/images"
        
        createArrayOfImgurImages(fromUrl: urlString) { array -> Void in
            
            self.listOfImgurImages = array
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func createArrayOfImgurImages(fromUrl urlString: String, completion: @escaping ([ImgurImage]) -> Void) {
        
        let url = URL(string: urlString)!
        let networkProcessor = NetworkProcessor()
        
        networkProcessor.downloadJSONDictionary(fromURL: url, completion: { (jsonDictionary) in
            
            if let arrayOfJSONData = jsonDictionary?["data"] as? Array<Any> {
                
                let imgurImages = self.convertJSONDataToImgurImages(jsonData: arrayOfJSONData)
                
                completion(imgurImages)
            }
            
        })
    }
    
    func convertJSONDataToImgurImages(jsonData listOfImages : Array<Any>) -> [ImgurImage] {
        
        var images = [ImgurImage]()
        
        for image in listOfImages {
            let imageData = image as? [String : Any]
            let imgurImage = ImgurImage(imageDictionary: imageData!)
            images.append(imgurImage)
        }
        return images
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfImgurImages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ImageTableViewCell"
        let image = listOfImgurImages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ImageTableViewCell else {
            fatalError("The dequeued cell is not an instance of ImageTableViewCell.")
        }
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = "Title: \(image.title ?? "")"
        cell.widthLabel.text = "Width: \(image.width ?? 0)"
        cell.heightLabel.text = "Height: \(image.height ?? 0)"
        
        cell.uploadDateLabel.text = image.uploadDate
        cell.uploadTimeLabel.text = image.uploadTime
        cell.viewsLabel.text = "Views: \(image.views ?? 0)"
        
        cell.editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        
        if let cachedImage = imageCache["imageIndex: \(indexPath.row)"] {
            cell.imagePreview.image = cachedImage
        } else {
            
            getDataFromUrl(url: image.link!) { data in
                
                DispatchQueue.main.async {
                    let imageFromData = UIImage(data: data!)
                    self.imageCache["imageIndex: \(indexPath.row)"] = imageFromData
                    cell.imagePreview.image = imageFromData
                }
                
            }
            
        }
        
        return cell
    }
    
    @objc func editButtonPressed(sender : UIButton) {
        selectedRow = sender.tag
        self.performSegue(withIdentifier: "openImageEditorSegue",sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
            indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        return indexPath
    }
    
    func getDataFromUrl(url:String, completion: @escaping ((_ data: Data?) -> Void)) {
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { (data, response, error) in
            completion(data)
        }.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? ImageEditorViewController
        destination?.image = listOfImgurImages[selectedRow]
    }
    
}
