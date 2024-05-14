module FileStorageService

sig FileStorageService {
	file: set File,
	fileID: set FileID,
	userName: set Username
	}

sig Username {}
abstract sig FileID {}
sig assignedID, notassignedID extends FileID{}
sig Time {}



sig File {
    username: Username,
    fileID: assignedID,
	content: String,
    createTime: Time,
    updateTime: Time,
	expiryTime: Time
}

pred CreateNewFile[fs,fs": FileStorageService, fil: File, username": Username, fileID": assignedID, createTime": Time, expiryTime": Time] {
    // Ensure the fileID is unique
    //no fs.file.fileID and fileID
	
	// Create a new file with the given attributes
	fil.fileID = assignedID
   	fil.username =  username" 
	fil.createTime = createTime"
	fil.expiryTime = expiryTime"
    
	//add new file to the StorageService
    fs".file = fs.file + fil 
	
	//send report
}


pred WriteToFile[fs, fs": FileStorageService, fil: File, data" : String, fileID": assignedID, updateTime": Time, username": Username] {
    // update new file
    fil.updateTime = updateTime"
	fil.username =  username" 
 	fil.content = data"
	fil.fileID = fileID"
	
	//add new edited file to the StorageService
    fs".file = fs.file + fil
	
	//send report 
}

//
pred ReadFile[fs: FileStorageService, file: File] {

    // send report

}
//
pred DestroyFile[fs: FileStorageService, id: FileID, username: Username ] {
	
	//check if file exists
	
	
	//check owner 
	
	
    // Remove the file from the storage service
    fs.file' = fs.file - file
}

//
//fact {
//    // Each file has a unique fileID
//    all f1, f2: File | f1 != f2 => f1.fileID != f2.fileID
//    // Each file is associated with exactly one username
//    all f: File | one username: Username | f.username = username
//}

run {} for 2
