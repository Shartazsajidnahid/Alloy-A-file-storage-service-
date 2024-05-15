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

sig Stringg{}

sig File {
    username: one Username,
    fileID: one assignedID,
	content: Stringg,
    createTime: Time,
    updateTime: Time,
	expiryTime: Time
}

abstract sig Report{}
sig successReport, NoSuchFileReport, NoSpaceReport, NotOwnerReport, NotKnownUserReport, BadOperationReport extends Report{}

 

//run FindFileByID for 2

pred CreateNewFile [fs,fs": FileStorageService, fil: File, username": Username, fileID": assignedID, createTime": Time, expiryTime": Time] {
	
	// Create a new file with the given attributes
	fil.fileID = fileID"
   	fil.username =  username" 
	fil.createTime = createTime"
	fil.expiryTime = expiryTime"
    
	//add new file to the StorageService
    fs".file = fs.file + fil 
	
	//send report
	//return successReport
}


pred WriteToFile[fs, fs": FileStorageService, fil, fil": File, data : Stringg, fileID": assignedID, updateTime": Time, username": Username] {
    
	//check if file exists
	FileExists [ fs , fileID" ]

	// update new file
	fil".fileID = fileID"
	fil".createTime = updateTime"
    fil".updateTime = updateTime"
	fil".username =  username"

 	fil".content = fil.content + data
	
	
	//add new edited file to the StorageService
    fs".file = fs.file + fil"
	
	//send report 
}
pred FileExists [fileStorage: FileStorageService, id: FileID] {
	one f: fileStorage.file | f.fileID = id
}

pred isOwner [fs : FileStorageService, id: FileID, user: Username] {
	one f: fs.file | f.fileID = id and f.username = user
}

pred DestroyFile[fs, fs": FileStorageService, id: FileID, user: Username ] {
	
	//check if file exists
	FileExists [ fs , id ]
	
	//check owner 
	isOwner [ fs, id, user ]

	fs".file = fs.file 
    // Remove the file from the storage service

	all f: fs.file | f.fileID = id implies fs".file = fs".file - f

    //fs".file' = fs.file - file
}

run DestroyFile for 2


fact {
    // Each file has a unique fileID
    all f1, f2: File | f1 != f2 => f1.fileID != f2.fileID

    // Each file is associated with exactly one username
    all f: File | one user: Username | f.username = user
}


//
//pred ReadFile[fs: FileStorageService, file: File] {
//	
//    // send report
//
//}
//

run {} for 2
