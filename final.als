module FileStorageService

abstract sig Username {}
sig Client, Guest extends Username{}

abstract sig FileID {}
sig assignedID, notassignedID extends FileID{}

sig Time {}

sig Stringg{}

sig File {
    username: one Client,
    fileID: one assignedID,
    content: Stringg,
    createTime: Time,
    updateTime: Time,
    expiryTime: Time
}

sig FileStorageService {
    file: set File,
    fileID: set FileID,
    userName: set Username
}



abstract sig Report{}
sig successReport, NoSuchFileReport, NoSpaceReport, NotOwnerReport, NotKnownUserReport, BadOperationReport extends Report{}

 

//run FindFileByID for 2

pred CreateNewFile [fs,fs": FileStorageService, newfile: File, newusername: Client, newfileID: assignedID, newcreateTime: Time, newexpiryTime: Time] {
	
	// Create a new file with the given attributes
	newfile.fileID = newfileID
   	newfile.username =  newusername
	newfile.createTime = newcreateTime
	newfile.expiryTime = newexpiryTime
    
	//add new file to the StorageService
    	fs".file = fs.file + newfile
	
	//send report
	//return successReport
}

pred FileExists [fileStorage: FileStorageService, id: FileID] {
	one f: fileStorage.file | f.fileID = id
}
pred WriteToFile[fs, fs": FileStorageService, fil, fil": File, data : Stringg, fileID": assignedID, updateTime": Time, expiryTime": Time, username": Client] {
    
	//check if file exists
	FileExists [ fs , fileID" ]

	// update new file
	fil".fileID = fileID"
	fil".createTime = updateTime"
	fil".updateTime = updateTime"
	fil".expiryTime = expiryTime"
	fil".username =  username"

 	fil".content = fil.content + data
	
	
	//add new edited file to the StorageService
	fs".file = fs.file + fil"
	
	//send report 
}


pred isOwner [fs : FileStorageService, id: FileID, user: Client] {
	one f: fs.file | f.fileID = id and f.username = user
}

pred DestroyFile[fs, fs": FileStorageService, id: FileID, user: Username ] {
	
	//check if file exists
	FileExists [ fs , id ]
	
	//check owner 
	isOwner [ fs, id, user ]

	//fs".file = fs.file
    // Remove the file from the storage service

	one f: fs.file | f.fileID = id implies fs".file = fs.file - f
}


fact {
    // Each file has a unique fileID
    all f1, f2: File | f1 != f2 => f1.fileID != f2.fileID

    // Each file is associated with exactly one username
    all f: File | one user: Username | f.username = user
}

fun ReadFile[fs: FileStorageService, id: FileID] : set File {
  { f: File | f in fs.file and f.fileID = id}
}

run ReadFile for 2

//
//pred ReadFile[fs: FileStorageService, file: File] {
//	
//    // send report
//
//}
//

//run {} for 2
