use sha256;
use std::{fs, io::Read};

pub fn hash_file(file: &mut fs::File) -> String {
    let mut buffer = Vec::new();
    file.read(buffer.as_mut()).unwrap();

    sha256::digest(buffer.as_slice()).to_string()
}
