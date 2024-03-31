use sha256;
// use std::{fs, io::Read};

pub fn hash_file(file: &Vec<u8>) -> String {
    sha256::digest(file.as_slice()).to_string()
}
