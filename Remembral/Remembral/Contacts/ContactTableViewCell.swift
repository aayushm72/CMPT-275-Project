//
//  ContactTableViewCell.swift
//  Remembral
//
//  Team: Group 2
//  Created by Alwin Leong on 11/27/18.
//  Edited: Alwin Leong
//
//  Contact Table View Cell Setup
//  Will be used in Version 3
//  Known bugs:
//
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    // Prepare Cell for service.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// For the Name Cell only.
class ContactNameOnlyTableViewCell : UITableViewCell {
    var cellLabel: UILabel!
    
    // Initialize cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellLabel = UILabel()
    }
    // Check if initializer worked
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set selected to nothing.
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
