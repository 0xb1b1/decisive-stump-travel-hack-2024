use sha256;
// use std::{fs, io::Read};

pub fn hash_file(file: &Vec<u8>) -> String {
    // Hash the file
    sha256::digest(file.as_slice())
}
